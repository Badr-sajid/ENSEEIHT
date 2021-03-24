package simplepdl.util;


import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import simplepdl.Process;
import simplepdl.*;
import petrinet.*;
 

public class SimplePDL2PetriNet {

	// La fabrique pour fabriquer les éléments de PetriNet
    static PetrinetFactory myFactory;
    static PetriNet mypetri;
    
    
    static Map<String, Place> Ready = new HashMap<String, Place>();
    static Map<String, Place> Started = new HashMap<String, Place>();
    static Map<String, Place> Running = new HashMap<String, Place>();
    static Map<String, Place> Finished = new HashMap<String, Place>();
    static Map<String, Transition> Start = new HashMap<String, Transition>();
    static Map<String, Transition> Finish = new HashMap<String, Transition>();
    static Map<String, Ressource> DemandeRessource = new HashMap<String, Ressource>();
    static Map<String, Ressource> RetourRessource = new HashMap<String, Ressource>();
    
	public static void main(String[] args) {
		
		// Charger le package SimplePDL afin de l'enregistrer dans le registre d'Eclipse.
		SimplepdlPackage packageInstanceSimplePDL = SimplepdlPackage.eINSTANCE;
		// Charger le package PetriNet afin de l'enregistrer dans le registre d'Eclipse.
		PetrinetPackage packageInstancePetriNet = PetrinetPackage.eINSTANCE;
		
		// Enregistrer l'extension ".xmi" comme devant être ouverte à 
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("xmi", new XMIResourceFactoryImpl());
		
		// Créer un objet resourceSetImpl qui contiendra une ressource EMF (le modèle)
		ResourceSet resSet = new ResourceSetImpl();
		
		// Créer le modèle de sorte (PetriNet.xmi)
		URI SortieURI = URI.createURI("Models/SimplePDL2PetriNet.xmi");
		Resource Sortie = resSet.createResource(SortieURI);
		
		// Créer un objet resourceSetImpl qui contiendra une ressource EMF (le modèle)
		ResourceSet resSetModel = new ResourceSetImpl();
		// Charger la ressource (notre modèle)
		URI modelURI = URI.createURI("Models/sujet-pdl.xmi");
		Resource resource = resSetModel.getResource(modelURI, true);
		
		
		
		// Récupérer le premier élément du modèle (élément racine)
		Process process = (Process) resource.getContents().get(0);
		
		// Instancier la fabrique
	    myFactory = PetrinetFactory.eINSTANCE;
	    
	    // Créer le PetriNet
	    mypetri = myFactory.createPetriNet();
	    mypetri.setName(process.getName());
	    Sortie.getContents().add(mypetri);
	    
	    
	    for (Object o : process.getProcessElements()) {
	    	
	    	// Conversion WorkDefinition to Place
			if (o instanceof WorkDefinition) {
				WorkDef((WorkDefinition)o);
			}
			
	    	// Conversion WorkSequence to Arc
			else if (o instanceof WorkSequence) {
				WorkSeq((WorkSequence)o);
			}

	    	// Conversion Ressource to Place
			else if (o instanceof Ressource) {
				ConvertRessource((Ressource)o);
			}
		}
	    
	    // Sauvegarde de la ressource de sortie
	    try {
	    	Sortie.save(Collections.EMPTY_MAP);
	    } catch (Exception e) {
	    	e.printStackTrace();
	    }
	}

	private static void ConvertRessource(Ressource ressource) {
		// Création de la Place Ressource
		Place PlaceRessource = myFactory.createPlace();

			// Paramétrage des Places
		// Nommer la ressource
		PlaceRessource.setName(ressource.getName());
		// Initialisation du nombre de jeton
		PlaceRessource.setJetons(ressource.getQuantity());
		
		// Ajout de la Place à mypetri
		mypetri.getPetriElement().add(PlaceRessource);
		
		// Liaison Ressource-WorkDefinition
		for (Demande d : ressource.getDemande()) {
			// Ajout de l'arc entre la PlaceRessource et 
			// la transition start correspondante
			Arc arcDemande = myFactory.createArc();
			arcDemande.setSource(PlaceRessource);
			arcDemande.setDestination(Start.get(d.getWorkdefinition().getName()));
			arcDemande.setJetons(d.getOccurences());
			mypetri.getPetriElement().add(arcDemande);
			
			// Ajout de l'arc entre la PlaceRessource et 
			// la transition finish correspondante
			Arc arcRetour = myFactory.createArc();
			arcRetour.setSource(Finish.get(d.getWorkdefinition().getName()));
			arcRetour.setDestination(PlaceRessource);
			arcRetour.setJetons(d.getOccurences());
			mypetri.getPetriElement().add(arcRetour);
		}
		
	}

	private static void WorkSeq(WorkSequence workSeq) {
		// Création de l'arc
		Arc myArc = myFactory.createArc();
		
		switch (workSeq.getLinkType()) {
		case START_TO_START :
			myArc.setSource(Started.get(workSeq.getPredecessor().getName()));
			myArc.setDestination(Start.get(workSeq.getSuccessor().getName()));
			break;
		case START_TO_FINISH :
			myArc.setSource(Started.get(workSeq.getPredecessor().getName()));
			myArc.setDestination(Finish.get(workSeq.getSuccessor().getName()));
			break;
		case FINISH_TO_START :
			myArc.setSource(Finished.get(workSeq.getPredecessor().getName()));
			myArc.setDestination(Start.get(workSeq.getSuccessor().getName()));
			break;
		case FINISH_TO_FINISH :
			myArc.setSource(Finished.get(workSeq.getPredecessor().getName()));
			myArc.setDestination(Finish.get(workSeq.getSuccessor().getName()));
			break;
		default: break;
		
		}
		myArc.setType(ArcType.READ_ARC);
		myArc.setJetons(1);
		
		// Ajout de l'arc à myetri
		mypetri.getPetriElement().add(myArc);
		
	}

	private static void WorkDef(WorkDefinition workDef) {
		// Création des Places
		Place PlaceReady = myFactory.createPlace();
		Place PlaceStarted = myFactory.createPlace();
		Place PlaceFinished = myFactory.createPlace();
		Place PlaceRunning= myFactory.createPlace();
		
		// Création des Transitions
		Transition TransitionStart = myFactory.createTransition();
		Transition TransitionFinish = myFactory.createTransition();
		
		// Création des Arcs
		Arc Arc_Ready_Start = myFactory.createArc();
		Arc Arc_Start_Started = myFactory.createArc();	
		Arc Arc_Start_Running = myFactory.createArc();
		Arc Arc_Running_Finish = myFactory.createArc();
		Arc Arc_Finish_Finished = myFactory.createArc();
		
			// Paramétrage des Places
		// Determination du nom des Places
		PlaceReady.setName(workDef.getName() + "_ready");
		PlaceStarted.setName(workDef.getName() + "_started");
		PlaceFinished.setName(workDef.getName() + "_finished");
		PlaceRunning.setName(workDef.getName() + "_running");
		
		// Initialisation du jeton des Places
		PlaceReady.setJetons(1);
		PlaceStarted.setJetons(0);
		PlaceRunning.setJetons(0);
		PlaceFinished.setJetons(0);

		
			// Paramétrage des Transitions
		// Determination du nom des Transitions
		TransitionStart.setName(workDef.getName() + "_start");
		TransitionFinish.setName(workDef.getName() + "_finish");
		
			// Paramétrage des Arcs
		// Determination de la source et la destination de chaque Arc
		Arc_Ready_Start.setSource(PlaceReady);
		Arc_Ready_Start.setDestination(TransitionStart);
		
		Arc_Running_Finish.setSource(PlaceRunning);
		Arc_Running_Finish.setDestination(TransitionFinish);
		
		Arc_Start_Started.setSource(TransitionStart);
		Arc_Start_Started.setDestination(PlaceStarted);
		
		Arc_Start_Running.setSource(TransitionStart);
		Arc_Start_Running.setDestination(PlaceRunning);
		
		Arc_Finish_Finished.setSource(TransitionFinish);
		Arc_Finish_Finished.setDestination(PlaceFinished);
		
		// Determination du type de chaque Arc
		Arc_Ready_Start.setType(ArcType.NORMAL);
		Arc_Running_Finish.setType(ArcType.NORMAL);
		Arc_Start_Started.setType(ArcType.NORMAL);
		Arc_Start_Running.setType(ArcType.NORMAL);
		Arc_Finish_Finished.setType(ArcType.NORMAL);
		
		// Determination des jetons de chaque Arc
		Arc_Ready_Start.setJetons(1);
		Arc_Running_Finish.setJetons(1);
		Arc_Start_Started.setJetons(1);
		Arc_Start_Running.setJetons(1);
		Arc_Finish_Finished.setJetons(1);
	
		
		// Ajout des Places à mypetri
		mypetri.getPetriElement().add(PlaceReady);
		mypetri.getPetriElement().add(PlaceStarted);
		mypetri.getPetriElement().add(PlaceRunning);
		mypetri.getPetriElement().add(PlaceFinished);
		
		// Ajout des Transitions à mypetri
		mypetri.getPetriElement().add(TransitionStart);
		mypetri.getPetriElement().add(TransitionFinish);
		
		// Ajout des Arcs à mypetri
		mypetri.getPetriElement().add(Arc_Ready_Start);
		mypetri.getPetriElement().add(Arc_Running_Finish);
		mypetri.getPetriElement().add(Arc_Start_Started);
		mypetri.getPetriElement().add(Arc_Start_Running);
		mypetri.getPetriElement().add(Arc_Finish_Finished);
		
		// Mise à jour des maps
		Ready.put(workDef.getName(), PlaceReady);
	    Started.put(workDef.getName(), PlaceStarted);
	    Running.put(workDef.getName(), PlaceRunning);
	    Finished.put(workDef.getName(), PlaceFinished);
	    Start.put(workDef.getName(), TransitionStart);
	    Finish.put(workDef.getName(), TransitionFinish);
		

	}

}

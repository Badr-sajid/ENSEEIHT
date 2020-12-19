machine fenetre {
   event ouvrir
   event fermer
   region r {
      state ouverte starts ends
      state fermee
   }
   from r.ouverte to r.fermee on fermer
   from r.fermee to r.ouverte on ouvrir
}

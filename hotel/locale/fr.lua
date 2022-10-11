local Translations = {
    error = {
        no_key = 'vous n\'avez pas la clé',
        not_hotel = 'Que faite vous ? Allez vous-en ! '
    },
    success = {
        key = 'Porte ouverte',
        multipass = 'Porte ouverte avec multipass'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
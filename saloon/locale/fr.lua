local Translations = {
    error = {
        no_key = 'vous n\'avez pas la clé',
        not_saloon = 'Que faite vous ? Allez vous-en ! ',
        craft_error = 'Pas assez de matériaux'
    },
    success = {
        key = 'Porte ouverte',
        multipass = 'Porte ouverte avec multipass',
        craft_ok = 'vous avez craft x1 '
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
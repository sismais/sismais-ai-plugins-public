# Índice de Regras de Validação e Campos

Mapa reverso que liga **campos do XML** e **regras de validação** a **todas as NTs que os definem, alteram ou adicionam exceções**. Use este índice para encontrar TODAS as NTs relevantes ao pesquisar sobre um campo ou regra.

> **Como usar:** Ao receber uma pergunta sobre um campo (ex: NCM) ou regra (ex: I05-10), consulte este índice para identificar TODAS as NTs que tocam esse tema — não apenas a NT mais óbvia.

> **Manutenção:** Ao incluir novas NTs na base, atualize este índice com as regras criadas/alteradas por cada NT.

---

## Por Campo do XML

### NCM (I05)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| I05-10 | **NT 2014.004**, **NT 2024.001** | NCM 8 dígitos obrigatório. Exceções: serviço/ajuste = "00"; item inclassificável = "00000000"; **MEI (CRT=4) + operação interna = "00000000" facultativo** |
| I05-20 | NT 2014.004 | NCM inexistente na tabela MDIC (implementação futura na NT original) |
| I05-24 / 105.24 | NT 2014.004 | NCM="00" indevido — só aceito para serviço (ISSQN) ou NF-e de ajuste |
| I05-40 | NT 2013.005 | Capítulo NCM inválido (77, 98, 99) |
| Tabela NCM | NT 2016.003, IT 2025.002 | Publicação e atualização da tabela NCM vigente |

### CFOP (I08)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| I08-140 | NT 2015.002, **NT 2021.004**, **NT 2024.001** | CFOPs válidos para devolução (finNFe=4). MEI: lista restrita. Exceção: gás natural (CFOP 5.949/6.949) |
| I08-150 | NT 2013.005, NT 2015.002, **NT 2023.003**, **NT 2024.001** | CFOPs válidos NFC-e. Exceções por UF: RS (5.949+CSOSN 900/CST 90), SP (5.949+CSOSN 900/CST 40). Inclui 5.910 |
| I08-160 | NT 2019.001, NT 2015.002 | CFOP de serviço (1.933, 2.933, 5.933, 6.933) sem grupo ISSQN → rejeição 374 |
| I08-170 | NT 2019.001, NT 2015.002 | CFOP diferente de serviço com grupo ISSQN → rejeição 374 |
| I08-171 | NT 2019.001 | CFOP de serviço no grupo ICMS (mod 55 apenas) → rejeição 374 |
| N12-40 | NT 2015.002, **NT 2023.003**, **NT 2024.001** | NFC-e CST (00,20,40,41,90) x CFOP. Exceções: RS (5.949+CST 90), CE (5.403/5.405+CST 90), SP (5.949+CST 40) |
| N12-44 | NT 2015.002, **NT 2024.001** | NFC-e CST=60 x CFOP (5.405, 5.656, 5.667, 5.910) |
| N12a-40 | NT 2015.002, **NT 2023.003**, **NT 2024.001** | NFC-e CSOSN (102,103,300,400,900) x CFOP. Exceções por UF similares à N12-40 |
| N12a-44 | NT 2015.002, **NT 2024.001** | NFC-e CSOSN=500 x CFOP |
| N12a-90 | **NT 2024.001** | MEI (CRT=4): CSOSN 102 aceita só 5102/6102; CSOSN 900 aceita lista restrita de CFOPs |
| N12a-91 | **NT 2024.001** | MEI (CRT=4) NFC-e: aceita somente CFOP 5102 |

### CRT — Código de Regime Tributário (C21)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| 7C21-10 | NT 2022.003, **NT 2024.001** | CRT divergente do cadastro Sefaz. CRT=4 deve ser MEI no cadastro |
| N12-20 | **NT 2023.001**, **NT 2024.001** | CST proibido para CRT=1 ou CRT=4. Exceção: CST monofásico (02, 15, 53, 61) |
| N12a-10 | **NT 2024.001** | CSOSN proibido para CRT diferente de 1 ou 4 |
| N12a-80 | **NT 2024.001** | MEI (CRT=4) NF-e: CSOSN válidos = 102, 300, 400, 900 |
| N12a-81 | **NT 2024.001** | MEI (CRT=4) NFC-e: CSOSN válidos = 102, 300 |
| N11-10 | **NT 2024.001** | Origem da mercadoria (orig) obrigatória quando CRT ≠ 4 |
| NA01-20 | NT 2015.003, NT 2017.002, **NT 2024.001** | ICMSUFDest (DIFAL) não exigido para CRT=1 ou CRT=4 (Simples/MEI) |
| I05-10 | NT 2014.004, **NT 2024.001** | NCM facultativo para MEI (CRT=4) em operação interna |
| I03-30 | NT 2017.001, **NT 2024.001** | GTIN facultativo para CRT=4 |
| I12-60 | NT 2017.001, **NT 2024.001** | GTIN tributável facultativo para CRT=4 |

### GTIN — Código de Barras (cEAN / cEANTrib)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| I03-30 | NT 2017.001, NT 2021.003, **NT 2024.001** | GTIN obrigatório (não pode ser branco). Exceção: CRT=4 (MEI) |
| I12-60 | NT 2017.001, NT 2021.003, **NT 2024.001** | GTIN tributável obrigatório. Exceção: CRT=4 (MEI) |
| Validação GTIN | NT 2021.003, NT 2017.001 | Consulta cadastro centralizado GTIN. Prazos e tratamentos |
| Consulta pública | NT 2022.001 | Web Service consulta pública do GTIN |

### cBenef — Código de Benefício Fiscal

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| I05f-10 | NT 2019.001 | cBenef informado para CST sem benefício (00, 10, 60) → rejeição 928 |
| I05f-20 | NT 2019.001 | cBenef incompatível com tipo de CST → rejeição 931 |
| I05f-30 | NT 2019.001 | cBenef informado sem vICMSDeson/motDesICMS → rejeição 934 |
| N12-84 | NT 2019.001 | CST com benefício (20,30,40,41,50,51,60,70,90) sem cBenef → rejeição 930 |
| N12-85 | NT 2019.001 | CST exige cBenef conforme tabela UF (por UF/modelo/CST) → rejeição 930 |
| N12-86 | NT 2019.001 | cBenef informado para CST sem benefício na tabela UF → rejeição 928 |
| N12-88 | NT 2019.001 | cBenef incompatível com CST na tabela UF → rejeição 931 |
| N12-94 | NT 2019.001 | cBenef vigente e compatível com CST na tabela UF → rejeição 931 |
| N12-98 | NT 2019.001 | cBenef existe e vigente na tabela UF. Não se aplica a CSOSN (SN) → rejeição 946 |
| N14a-10 | NT 2019.001 | cBenefRBC obrigatório quando pRedBC > 0 no CST 51 |
| N14a-20 | NT 2019.001 | cBenefRBC correto e vigente para CST 51 |
| Tabela cBenef | NT 2019.001 (seção 3.6.2) | Endereços das tabelas cBenef x CST por UF no Portal NF-e |
| Ativação por UF | NT 2019.001 (seção 3.6.1) | Datas/exceções/modelos por UF: DF, ES, GO, PR, RJ, RS, SC, SP |

### CST — Código de Situação Tributária (N12)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| N12-20 | **NT 2023.001**, **NT 2024.001** | CST proibido para CRT=1/4. Exceção: monofásico (02, 15, 53, 61) |
| N12-30 | **NT 2023.001** | CST x grupo tributação ICMS |
| N12-40 | NT 2015.002, **NT 2023.003**, **NT 2024.001** | NFC-e CST x CFOP (exceções por UF) |
| N12-44 | NT 2015.002, **NT 2024.001** | NFC-e CST=60 x CFOP |
| N12-70 | **NT 2023.001**, **NT 2023.003** | NF-e CST x CFOP (exceção CE para 5.403/5.405+CST 90) |
| N12-100 | **NT 2023.001** | CST monofásico — validações específicas combustíveis |
| N12-110 | **NT 2023.001** | CST monofásico — validações específicas combustíveis |

### CSOSN — Código de Situação da Operação no Simples Nacional (N12a)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| N12a-10 | **NT 2024.001** | CSOSN proibido para CRT diferente de 1 ou 4 |
| N12a-40 | NT 2015.002, **NT 2023.003**, **NT 2024.001** | NFC-e CSOSN x CFOP (exceções por UF) |
| N12a-44 | NT 2015.002, **NT 2024.001** | NFC-e CSOSN=500 x CFOP |
| N12a-70 | **NT 2024.001** | CSOSN x não contribuinte. Exceção: MEI (CRT=4) com CFOP 5904/6904+CSOSN 900 |
| N12a-80 | **NT 2024.001** | MEI NF-e: CSOSN válidos = 102, 300, 400, 900 |
| N12a-81 | **NT 2024.001** | MEI NFC-e: CSOSN válidos = 102, 300 |
| N12a-90 | **NT 2024.001** | MEI NF-e: CFOP x CSOSN (lista restrita) |
| N12a-91 | **NT 2024.001** | MEI NFC-e: somente CFOP 5102 |

### ICMS Monofásico — Combustíveis (CST 02, 15, 53, 61)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| I13-20 | **NT 2023.001** | Validação cProdANP (código ANP combustível) |
| LA17-10, LA17-20 | **NT 2023.001** | Campos combustível (origComb, pBio) |
| LA18-10, LA18-20, LA18-30 | **NT 2023.001** | Validações combustível |
| LA21-10, LA21-20 | **NT 2023.001** | Validações combustível |
| N37a-10, N39a-10, N43a-10 | **NT 2023.001** | ICMS monofásico — campos específicos por CST |
| N41-10, N41-20 | **NT 2023.001** | ICMS monofásico — validações |
| W06b.1-10, W06c-10, W06c.1-10 | **NT 2023.001** | Totalização ICMS monofásico |
| W06d-10, W06d.1-10, W06e-10 | **NT 2023.001** | Totalização ICMS monofásico |
| W16-10 | **NT 2023.001** | Total ICMS monofásico |

### ICMS Desonerado (vICMSDeson / motDesICMS)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| N12-90 | NT 2019.001 | vICMSDeson e motDesICMS obrigatórios para CST 20,30,40,41,50,70,90 (por UF) |
| N28-20 | NT 2019.001 | motDesICMS=7 (Suframa): CFOPs válidos específicos |
| I05f-30 | NT 2019.001 | cBenef informado exige vICMSDeson e motDesICMS |
| indDeduzDeson | **NT 2023.004** | Novo campo: indica se vICMSDeson deduz do vProd. Nos grupos CST 20, 30, 40/41/50, 70, 90 |

### Crédito Presumido (gCred / cCredPresumido)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| I05g-10 | NT 2019.001 | Grupo gCred não permitido na UF (a critério da UF). Exceção: NFF (tpEmis=3) |
| I05h-10 | NT 2019.001 | cCredPresumido correto, vigente e compatível na UF |

### Pagamentos (Grupo YA)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| YA09-20 | **NT 2023.004** | Valor máximo do troco |
| CNPJPag, UFPag, CNPJReceb, idTermPag | **NT 2023.004** | Campos de pagamento (facultativos) |
| ECONF | NT 2024.002 | Evento de Conciliação Financeira (separado da NT 2023.004 a partir da v1.10) |

### Transporte (Grupo X)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| X03-30 | NT 2021.004 | Validação transporte |
| X04-30 a X04-100 | NT 2021.004 | Validações placas, RNTRC, UF veículo/reboque |

### Destinatário (Grupo E / 5E17)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| E03a-30 | NT 2019.001 | IE + idEstrangeiro simultâneos proibidos |
| E14-30 | NT 2019.001 | Exterior com país=Brasil proibido |
| E16a-40 | NT 2019.001 | Não contribuinte deve ser consumidor final |
| 5E17-10 a 5E17-80 | NT 2019.001, **NT 2024.001** | Validações destinatário (IE, CNPJ, CPF, situação cadastral). Denegações convertidas em rejeições pela NT 2024.001 |

### ICMS Interestadual / DIFAL (Grupo NA)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| NA01-20 | NT 2015.003, NT 2017.002, **NT 2024.001** | ICMSUFDest obrigatório em operação interestadual+consumidor final+não contribuinte. 12 exceções. CRT=1/4 isento |

### Identificação da NF-e (Grupo B)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| B03-10 | NT 2019.001 | cNF não pode ser sequência fraca (00000000, 11111111, etc.) |

### Documentos Referenciados (Grupo BA)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| BA10-40 | NT 2019.001 | Contranota produtor: referencia somente NF de outro emitente |
| BA10-50 | NT 2019.001 | Contranota produtor: só referencia NF-e ou NF Mod 4 |
| BA20-20 | NT 2019.001 | Doc operação interna referenciado em operação interestadual/exterior |
| BA20-30 | NT 2019.001 | Cupom Fiscal referenciado (a critério da UF) |

### Medicamento (Grupo K)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| K01-10 | NT 2021.004 | Validação campo medicamento (suspensa na v1.34) |

### ISSQN (Grupo U)

| Regra | NTs que definem/alteram | Resumo |
|-------|------------------------|--------|
| U06-10 | NT 2021.004 | Validação ISSQN |
| NT 2022.004 | NT 2022.004 | Aperfeiçoamento da regra de validação do campo ISSQN |

---

## Índice Alfabético de Regras de Validação

| Regra | Campo/Grupo | NTs | Descrição curta |
|-------|-------------|-----|-----------------|
| B03-10 | cNF (B03) | NT 2019.001 | Código segurança fraco |
| BA10-40 | refNFP (BA) | NT 2019.001 | Contranota ref outro emitente |
| BA10-50 | refNFP (BA) | NT 2019.001 | Contranota só NF-e/Mod4 |
| BA20-20 | refECF/refNF (BA) | NT 2019.001 | Doc interno em op interestadual |
| BA20-30 | refECF (BA) | NT 2019.001 | Cupom fiscal referenciado |
| E03a-30 | IE/idEstrangeiro (E) | NT 2019.001 | IE + estrangeiro proibidos |
| E14-30 | cPais (E14) | NT 2019.001 | Exterior com país Brasil |
| E16a-40 | indIEDest/indFinal (E) | NT 2019.001 | Não contrib = consumidor final |
| H02-10 | nItem (H02) | NT 2019.001 | Ordem sequencial do item |
| I03-30 | cEAN (I03) | NT 2017.001, NT 2021.003, NT 2024.001 | GTIN obrigatório. Exceção: MEI |
| I05-10 | NCM (I05) | **NT 2014.004**, **NT 2024.001** | NCM 8 dígitos. Exceções: serviço, MEI+interna |
| I05-20 | NCM (I05) | NT 2014.004 | NCM inexistente tabela MDIC |
| I05-24 | NCM (I05) | NT 2014.004 | NCM=00 indevido |
| I05-40 | NCM (I05) | NT 2013.005 | Capítulo NCM inválido |
| I05f-10 | cBenef (I05f) | NT 2019.001 | cBenef + CST sem benefício |
| I05f-20 | cBenef (I05f) | NT 2019.001 | cBenef incompatível com CST |
| I05f-30 | cBenef (I05f) | NT 2019.001 | cBenef sem vICMSDeson |
| I05g-10 | gCred (I05g) | NT 2019.001 | Crédito presumido não permitido |
| I05h-10 | cCredPresumido (I05h) | NT 2019.001 | Código crédito presumido |
| I08-140 | CFOP (I08) | NT 2015.002, NT 2021.004, NT 2024.001 | CFOPs devolução |
| I08-150 | CFOP (I08) | NT 2013.005, NT 2015.002, NT 2023.003, NT 2024.001 | CFOPs NFC-e |
| I08-160 | CFOP (I08) | NT 2019.001, NT 2015.002 | CFOP serviço sem ISSQN |
| I08-170 | CFOP (I08) | NT 2019.001, NT 2015.002 | CFOP não-serviço com ISSQN |
| I08-171 | CFOP (I08) | NT 2019.001 | CFOP serviço no grupo ICMS |
| I12-60 | cEANTrib (I12) | NT 2017.001, NT 2021.003, NT 2024.001 | GTIN trib obrigatório. Exceção: MEI |
| I13-20 | cProdANP (I13) | NT 2023.001 | Código ANP combustível |
| K01-10 | Medicamento (K) | NT 2021.004 | Validação medicamento (suspensa) |
| LA17-10/20 | Combustível (LA) | NT 2023.001 | Campos combustível |
| LA18-10/20/30 | Combustível (LA) | NT 2023.001 | Validações combustível |
| LA21-10/20 | Combustível (LA) | NT 2023.001 | Validações combustível |
| N07-10 | CST 51 (N07) | NT 2019.001 | Diferimento: campos obrigatórios |
| N11-10 | orig (N11) | NT 2024.001 | Origem obrigatória quando CRT≠4 |
| N12-20 | CST (N12) | NT 2023.001, NT 2024.001 | CST proibido CRT 1/4 (exceto monofásico) |
| N12-30 | CST (N12) | NT 2023.001 | CST x grupo tributação |
| N12-40 | CST (N12) | NT 2015.002, NT 2023.003, NT 2024.001 | NFC-e CST x CFOP |
| N12-44 | CST (N12) | NT 2015.002, NT 2024.001 | NFC-e CST=60 x CFOP |
| N12-70 | CST (N12) | NT 2023.001, NT 2023.003 | CST x CFOP (exceção CE) |
| N12-84 | cBenef (N12) | NT 2019.001 | CST benefício sem cBenef |
| N12-85 | cBenef (N12) | NT 2019.001 | CST exige cBenef (por UF) |
| N12-86 | cBenef (N12) | NT 2019.001 | cBenef para CST sem benefício |
| N12-88 | cBenef (N12) | NT 2019.001 | cBenef x CST incompatível |
| N12-90 | vICMSDeson (N12) | NT 2019.001 | vICMSDeson/motDesICMS obrigatórios |
| N12-94 | cBenef (N12) | NT 2019.001 | cBenef vigente e compatível CST |
| N12-97 | CST 51 (N12) | NT 2019.001 | Diferimento sem informações (por UF) |
| N12-98 | cBenef (N12) | NT 2019.001 | cBenef existe e vigente (por UF) |
| N12-100 | CST monofásico (N12) | NT 2023.001 | CST monofásico combustíveis |
| N12-110 | CST monofásico (N12) | NT 2023.001 | CST monofásico combustíveis |
| N12a-10 | CSOSN (N12a) | NT 2024.001 | CSOSN proibido CRT≠1/4 |
| N12a-40 | CSOSN (N12a) | NT 2015.002, NT 2023.003, NT 2024.001 | NFC-e CSOSN x CFOP |
| N12a-44 | CSOSN (N12a) | NT 2015.002, NT 2024.001 | NFC-e CSOSN=500 x CFOP |
| N12a-70 | CSOSN (N12a) | NT 2024.001 | CSOSN x não contribuinte |
| N12a-80 | CSOSN (N12a) | NT 2024.001 | MEI NF-e: CSOSNs válidos |
| N12a-81 | CSOSN (N12a) | NT 2024.001 | MEI NFC-e: CSOSNs válidos |
| N12a-90 | CSOSN/CFOP (N12a) | NT 2024.001 | MEI NF-e: CFOP x CSOSN |
| N12a-91 | CSOSN/CFOP (N12a) | NT 2024.001 | MEI NFC-e: só CFOP 5102 |
| N14a-10 | cBenefRBC (N14a) | NT 2019.001 | cBenefRBC obrigatório CST 51 |
| N14a-20 | cBenefRBC (N14a) | NT 2019.001 | cBenefRBC correto CST 51 |
| N18-10 | modBCST/pMVAST (N18) | NT 2019.001 | modBCST=4 sem pMVAST |
| N18-20 | modBCST/pMVAST (N18) | NT 2019.001 | modBCST≠4 com pMVAST |
| N28-20 | motDesICMS (N28) | NT 2019.001 | Suframa: CFOPs válidos |
| NA01-20 | ICMSUFDest (NA) | NT 2015.003, NT 2017.002, NT 2024.001 | DIFAL obrigatório (12 exceções) |
| U06-10 | ISSQN (U) | NT 2021.004 | Validação ISSQN |
| W03-20 | vBC total (W03) | NT 2019.001 | BC máxima por modelo |
| W06b.1-10 | Total monofásico (W) | NT 2023.001 | Totalização ICMS monofásico |
| W06c-10 | Total monofásico (W) | NT 2023.001 | Totalização ICMS monofásico |
| W06d-10 | Total monofásico (W) | NT 2023.001 | Totalização ICMS monofásico |
| W06e-10 | Total monofásico (W) | NT 2023.001 | Totalização ICMS monofásico |
| W16-10 | Total monofásico (W) | NT 2023.001 | Total ICMS monofásico |
| X03-30 | Transporte (X) | NT 2021.004 | Validação transporte |
| X04-30 a X04-100 | Transporte (X) | NT 2021.004 | Placas, RNTRC, UF veículo |
| YA09-20 | Troco (YA) | NT 2023.004 | Valor máximo troco |
| Z02-10/20 | infAdic (Z) | NT 2021.004 | Informações adicionais NFC-e |
| Z13-10 | infAdic (Z) | NT 2021.004 | Informações adicionais |
| 1C03-10 | xNome emit (1C) | NT 2019.001 | Razão social diverge cadastro |
| 1C17-38 | Emitente (1C) | NT 2024.001 | Emitente não habilitado (rejeição) |
| 5E17-10 a 5E17-80 | Destinatário (5E) | NT 2019.001, NT 2024.001 | Validações destinatário |
| 7C21-10 | CRT (7C) | NT 2022.003, NT 2024.001 | CRT diverge cadastro |

---

## Mapa Temático (Tema → NTs relacionadas)

| Tema | NTs principais |
|------|---------------|
| **MEI / CRT=4** | NT 2024.001, NT 2019.001 (N12-20) |
| **Simples Nacional / CRT=1** | NT 2024.001 (N12-20, N12a-10), NT 2019.001 (N12-98 exc. CSOSN) |
| **NCM** | NT 2014.004, NT 2016.003, NT 2024.001, IT 2025.002 |
| **GTIN** | NT 2017.001, NT 2021.003, NT 2022.001, NT 2024.001 |
| **Benefício Fiscal / cBenef** | NT 2019.001 (principal), NT 2022.002 (cClassTrib) |
| **Combustíveis / Monofásico** | NT 2023.001 (principal) |
| **CFOP NFC-e** | NT 2023.003, NT 2024.001, NT 2015.002 |
| **DIFAL / Interestadual** | NT 2015.003, NT 2022.005, NT 2024.001 |
| **Reforma Tributária / IBS / CBS** | NT 2025.002 |
| **Pagamentos / ECONF** | NT 2023.004, NT 2024.002 |
| **Transporte** | NT 2021.004 |
| **Contingência / EPEC** | NT 2014.001, NT 2018.004, NT 2018.001 |
| **DANFE / QR Code** | NT 2020.004, NT 2025.001, Manual DANFE NFC-e |
| **Manifestação Destinatário** | NT 2020.001 |
| **Distribuição DF-e** | NT 2014.002 |
| **Denegação → Rejeição** | NT 2024.001 |
| **CNPJ Alfanumérico** | NTC 2025.001 |

---

> **Cobertura atual:** NTs indexadas: NT 2014.004, NT 2016.003, NT 2019.001, NT 2021.004, NT 2023.001, NT 2023.003, NT 2023.004, NT 2024.001, NT 2024.002. Para ampliar, leia cada NT e adicione suas regras a este índice.

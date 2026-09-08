Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013081.outbound.protection.outlook.com [52.103.51.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33884CCDEC;
	Tue,  8 Sep 2026 01:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830132; cv=fail; b=HMKRaU1KbFl74o2ZvoFFdPpdO8pmxlLqIvY/K+BGQFPsqONgv91i+okf/0R38v2QSK7uImX/8GFZKSewVli9GbQ5xARMfj28HqHEGxYTnKHS3EMRQ1icrgjC+Gxt3mBCVwTJyO0Phfv8oePbiv6RMFGXuMN1IjZrn3XpeRa9RvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830132; c=relaxed/simple;
	bh=/ZgWFl22dO9XYG6gOvp4xRWyoEJVFfA/WcHTQMQeWf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b0lAqt/Vzlcy1dtxr/EBxEq85FlEXyaXnSkqdUfgiCux9I7tcX1ZaSRptdYzD/S5EbdoMNfalfaGiYqvtjrw7DlZRm70Su/j2g4dSx5L3L3xnyFu6AnfvGM2NhF5oqkyFJ6BdIt63giTkQZA6O71vkXTmHiSL7QD4Jm6J7Dn1Vw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=QjlKfe4Q; arc=fail smtp.client-ip=52.103.51.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="QjlKfe4Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryc0+cpwJp79OHpWaX5AiFJFwkO5aD99G35C18kmMWPEmmWy0PoFrkXgFNDouh2UPC/DcTR9ItXMnEHzlV0aSMMuCpgWNL5vvqzg6iNTr4dn6/9F95uhDrxOooFwba5+b3Il1Sh0X31EQW+XyR9rHYL609Dbgv1Q/slGqiGsNNhLwyF/Hv5xC1z1umUvrBB63VvXuQxbAq014KZMSOALWnZIAfTB0pP7wWADttemtMXbCwiv/JE6Lu8jI1S2aL2Uu/767h6vzGfn+RmvC53G0pgOhSfjGsaL2YasMIiPrJlfCAIF4GEwqibbdmXI27l4778KAAidAOI29vhQ3pwQcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZgWFl22dO9XYG6gOvp4xRWyoEJVFfA/WcHTQMQeWf0=;
 b=wXMQWHpwYLfrz6rKTwMiQJuPetkyLMwExUSFgif1dr7hefZCfj+MOTB3e8Z+Cs6ee0lBuKQppCwaQvaHcdfiJJbxEfS3+2Q2fAmNNN6j+jnzwUfdQ/1H1X6RhPq35GYSvKfHDezk64SBr5p50JJfLiYsVLBb8erAOXhjx+I55qe6WNvis1oJzhPAA9FlT5Qpq2xwCVhRzM3Xh+sOJf4erUkSw9TCS6x/kF82NVKwQN1bwbiUVZ6EwCSTuc57xT2PVKlekemgw4gwA1MRM/JbliPuANZXMAQUO7HLsNnrPmLvhLhPUf6aTNdBXykF5hWLTE1zMySw7/ZkTiqlNR3D6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZgWFl22dO9XYG6gOvp4xRWyoEJVFfA/WcHTQMQeWf0=;
 b=QjlKfe4QatAahdMeVGJjMcBh9GE/utlWhHY9WI2ceO71KO6YF48bmsnhZxRFMt09gRW1oZN0LdGz2ja7SJbzRLpDnCQzqBIOFx3qwdnXko0XqKSXO+Hwy/8COvPWyes9QfF5xQLbCM5fbOMk0Gmu5DbYALXsYb3uA84dudl29r38SDZrY88/Wm1DCJToonT3nEc1KVqjprqGCwS0MXHXp9E7myuRkDqrGsm/lsaaEbV7oyr/nJafL9qXA4Z2LLWGAIi0lT4YGH47LaSXrKSgDgP6ePbROWRTDCT0Gu845OxrwywqaUj2zMMiVT7Wt4/qnqbMal9htY7q+juF/52aXA==
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:1d9::15)
 by AS8P251MB0088.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:34c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 01:15:28 +0000
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35]) by PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 01:15:28 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Jerome Pouiller <jerome.pouiller@silabs.com>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: wfx: validate num_tx_confs against HIF message length
Date: Tue,  8 Sep 2026 02:15:25 +0100
Message-ID:
 <PAXP251MB0010D1F622BB378EF46B2C32C8B12@PAXP251MB0010.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <4973500.rnE6jSC6OK@nb0018864>
References: <AS8P251MB000103B16A46379DFADEDB21C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <4973500.rnE6jSC6OK@nb0018864>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0320.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::13) To PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:1d9::15)
X-Microsoft-Original-Message-ID:
 <20260908011526.115281-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP251MB0010:EE_|AS8P251MB0088:EE_
X-MS-Office365-Filtering-Correlation-Id: bf44f696-ffa1-4524-de92-08df0d46ab0f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|5072599009|37011999003|15080799012|12121999013|8060799015|23021999003|25031999004|2604032031799003|19110799012|24021099003|55001999006|51005399006|3412199025|26104999009|440099028|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J0riOtCXA42VTFVI+lSfup9B5mrGqOZr3F8zJbbR6jG86oakPcPK0F44y2Xu?=
 =?us-ascii?Q?QW3TkUJ7f/QtJpj2L1QWFOaCTdJsw7t20X4x6EusX+WxEOkhBwSI3cjZFsdt?=
 =?us-ascii?Q?dR+uWHXdh5+8cH+LGNnGKKii68dHMjGB83FXn9pmPnvbjknb9E+vpNfU0WMD?=
 =?us-ascii?Q?rxJfYp8NnzpD6GqiH8BHeWVBl/OCWQGxwSZcH8IeU8+c1+AM4a4y4BWEjPST?=
 =?us-ascii?Q?kI5cNvpPVEiGlZjYL2blMuyiVHQ6G3rRTQPgXazasZRH97Vb6Y7kcn9nTy7L?=
 =?us-ascii?Q?vcKlgYRr+3IeDeTTNmgkBL8o7PvZEXUcyOnQdBlTdlZ9LJUyR6IOo54o3R22?=
 =?us-ascii?Q?QVFIBjPSpoIoE+1ZPYSFMUCFEngkeOHTU+5D0UFNx3EGziAF1PO7iHR1DXzU?=
 =?us-ascii?Q?UphhiMdT1FdnPiQuo8h8cqBAb5oj6lQJkjn3Eyswd4aIwkg+cSU48NudKBdx?=
 =?us-ascii?Q?yIZYioLRl/H78HqVTRVZXvHztr5FgiA+KmALfgCcRDBl3QsevaLhsYS7bpPj?=
 =?us-ascii?Q?TDM9LTGzJiG1130Y88wO6Vjy61rp6+3J3Yv3/V5bWPhOCLIAxAEM5qaM8u5O?=
 =?us-ascii?Q?fAp9BmRGn/pfpyosPjNtgaCGa0/7UL4ab3FKOiEjew29/nZpJGMTlh1bfpfE?=
 =?us-ascii?Q?1S9KWZcSQsME6nNWznbIunY78NX/WO5WYC1JtJh+RC4QUa96JX241DHZx5Rb?=
 =?us-ascii?Q?BeeIwqJAFh6Foa7aStX+H82rTjn31rbLRiK2fA6ODSv5TcTtyrBrdDhL8Lvh?=
 =?us-ascii?Q?JYdBIXjtYN1/MujSqjKDnRx1uOB8BYKArLmOj1LC9rBnb3a/J7T3aFAA2rTy?=
 =?us-ascii?Q?S4Q8MYMjAmMfre2D94+Psmb4SQL/vQhp8HFQyPVsr82zv9OM/1Sfhni2kZmH?=
 =?us-ascii?Q?LEXr24O65Kn4UxSQvvISEW7GRe29fIin0UxD0UnuaGJNRayaR0o6x/rBdDLc?=
 =?us-ascii?Q?rEa7ALpq/kx+SR6X+VWdnHCv7au372ntr1XERpXE8HUtqqeG9eorFFaujU0/?=
 =?us-ascii?Q?xs0DeR7Olfw0329+N0WDmu/c4Cv1P4iYcIhdq71KGi4p0Z8n2Qx94cawX3Nd?=
 =?us-ascii?Q?MnLig9cTcwlSZLsse4wEgj4SQ2ExOpB6pPeWIZNOC5+0InCxXtK+Cla59u8i?=
 =?us-ascii?Q?Rr8/Z+2iZuBvHgemI2pf7ltcHB5W31lfRg=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oDewAuRLVi0zFFi+/6WRNvLyWLv+L9KkAyy+XlreJvMfd/JVYZlB16IMY6dC?=
 =?us-ascii?Q?23f3XHWPStbKW0fvVKBT9lhvgHlXSahlQT4g7ZeTOgP6rehE3yioAfDCZQ0a?=
 =?us-ascii?Q?7ISibkj+VvFLJmCwY7MpTCdfeNv/tdFDHFr9aQ9UlCjkU9u8CBinZZx/mkWm?=
 =?us-ascii?Q?wbskxvI/9591wetMf3kCWMGvm4MbXNwZJwLHSHsH/0YZxNe1aAWyzatnon2r?=
 =?us-ascii?Q?slCpLSxTOiokVS7obbI28/8aCihspRzE/0C3Da0u9RmxlVarsBWPW5lJB6LO?=
 =?us-ascii?Q?vK9NSiiVyRttvLmfpqBLxkLJaxQMO/Q1tmlBe92q2dbHC3RmvghPNUCbeKEK?=
 =?us-ascii?Q?yFPMaxNdXM5D/OiLjc1u6TiNmo/uQI6VVkeKDLJGpy5BdcpFGsrmnsYmJNgK?=
 =?us-ascii?Q?npgGYUnU/1DcBckM9eszl7GHjUEJEfF6FmcUUYfXlWbv783CIwoz8SS++EtB?=
 =?us-ascii?Q?uUCyXkN8xRPF4p18rAnPLUSOABBYHWbrPfEUJlRgqfnGRcvZogfHwc2JlQ8K?=
 =?us-ascii?Q?yC+G97zOg6r0yfjCVsG2MliQ7DEUl81celtFU3tbEfxi8iIoTVSqMLFpSrVj?=
 =?us-ascii?Q?EExwvrXXFscjbEqgCMWH80sODSfCBxp33/yTH4a3bE2jW3i4ytPbe3NZiJK3?=
 =?us-ascii?Q?Er45iuwkssMAiu06Ar9HQaMqec6VD3nUTDLQV3YKBQaJGkn5WEWA9XXV0nk6?=
 =?us-ascii?Q?l3Y04Ugwr2BbRlrzWLhf7mKZeq7XeSCSC3YhW+2RD6GQXaR662e6hyqU89DW?=
 =?us-ascii?Q?xa+JAoqzQN3AVa4xSiwPrsIbID3dFQQAgN0/Vel/DvCj9/m3rWVDEGR9akmn?=
 =?us-ascii?Q?sBOC1/DkImd/Yb7UkFkFtMIkRDbunll8Ht/Q06FE8vk4v2xg9omYXsflsYuV?=
 =?us-ascii?Q?IBNZslUdShBUB6ZR14cf1f3qPheYUGEx00RGBvH+7fLJBeANnf5/4jY4feC2?=
 =?us-ascii?Q?tUm8Krvo5qAM+GYWwzMMOmY7Ks7ntrhr+Yh8yX8J24UYsOHa3MNUr5a2Q1Fv?=
 =?us-ascii?Q?I2cjzhmsAHXhUxOuSV8i6ByssMu9d8tZywOtbjIG1ewxWmhGJMmyipij8VKC?=
 =?us-ascii?Q?TYOB8ZQc+Fb2s2iSn4ZYI8cLp/Zk5lvBmWB6qbU8bOQ3THFDBUb7RPAYal5L?=
 =?us-ascii?Q?tHQ421z0DHyZlKgmrj01lfezdDON/MHmzDA0DiQx4hwrU0RevIZMMwSexkqu?=
 =?us-ascii?Q?miUJjVQNopO4K7/G9rWYPFWy+K9fjGA3zUKGgp43pWDRjR1SraSgkgxGk0ia?=
 =?us-ascii?Q?rV2znHcXz03gT57PQDjo/f1txaIr0QbUOqgNC8F1E6S0iS09H4sC23UsVAJg?=
 =?us-ascii?Q?JZEeOzyJeY+l4tvV/EvQl1rIcWpBaJli+COKEiOpmxEMIG/Xu924l49puiAN?=
 =?us-ascii?Q?jEDGhZmxL5S/2Zh07VGlt5+qkpbLEzXA9OabayqH/G3Jc75ZV8KcPTflehp8?=
 =?us-ascii?Q?3R1Vn++eeKrUTC+iBeaVTwvEUIIynvHw?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: bf44f696-ffa1-4524-de92-08df0d46ab0f
X-MS-Exchange-CrossTenant-AuthSource: PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 01:15:28.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P251MB0088

On Mon, Sep 07, 2026 at 09:52:03PM +0200, Jerome Pouiller wrote:
> body->num_tx_confs is already used in rx_helper(). So, the
> error detection happens to late.

Yes that makes sense. The check should live in rx_helper(), next to
the existing hif->len consistency check, so that the tx_buffers_used
accounting never sees an incorrect count either.

> Until now, I have considered the device semi-trusted, so skipping this
> test does not shock me.
>
> (I tend to prefer the readability of the code rather to clutter it with
> plenty of error paths impossible to reach and impossible to test)

Understood. If you would take a single check in rx_helper() I am happy
to send that as v2; otherwise I can drop it. Thanks.

Kind Regards

Aamir A.

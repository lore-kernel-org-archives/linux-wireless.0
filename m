Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazolkn19013085.outbound.protection.outlook.com [52.103.46.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646C221D3E8;
	Tue,  8 Sep 2026 01:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.46.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788829601; cv=fail; b=U5gx2ITVLWgIJ4wTPAzPMe6ogz8ahErxkzcvpPZJM7qcQRDEZr0B8ukQhsuVVZat/fs/Q3vZA7gkYW6pGTVsAOuIwZjzxSKLJiaHEi4eamzuP1kJyEaT3O9dcNZ6o3/uZt3n6tkDPuAyzUqQiMmJ27Vz4LRE86Ffkw7CEhmn7Sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788829601; c=relaxed/simple;
	bh=bm8uBxMxHoh2ru5fUipcuHWACEBf6mMjbYaMtPFkp3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G/HvQDk1jA0K8924sbGgiJj7Rq+QLixlTs7V7ZOZLhhmivtmr9JDq/G6g92GvpSKGaezC9GiOoZk3BRZv3cxU/yhEeX9p6aQN/ktw+EReu8dgoZ1VctBGFQLQ3KZzRxzmgPJQun9hBPwbT+DziexDYQuqplTlK9D0zm7i5dMtWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=OOyjyWmy; arc=fail smtp.client-ip=52.103.46.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="OOyjyWmy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=taDB2c3sup+oaVCQETAVUGOECOlMyi1HC0iyxwFJVOGdda0SZ9MbV8P9WAcN/jWhoJb7JWxkL9gQZ3GvyHvoKFItjfYARJNRCvYjrg88vsVwLI5LwVBZJRr8EKNTHvlrz3QHMs+NgpD41ZCILWmE3XyOYo4KM1nJUye4xu+e5k7fQDaE/8NvRbHhSuJY7oZLpwDCf9FeFfAupg9EYRO/kNl0OB4fhNFbFW5hTvvQN6lo1hwq4yvErBFUMhBzTTd2klh6QhQYrRytKa5g62HQm6SxnQPzxeCLOl/lpL+TlIcdVegpUyhIf08foNILRcuajX3lzQRpNDZ0x+6S6TE+Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bm8uBxMxHoh2ru5fUipcuHWACEBf6mMjbYaMtPFkp3E=;
 b=liuf9zYtlnPVOX+j+VfE6uWkHhQY3YyJLB4o7rpXmbaHJTOdGo0qmfmcZdXpq/2F+GZLBYF5zWH3dSmG1MIjhjeGc8sY4jvz+cvf1WN50+KtEm6yntDiftVZSCVnpx1txMVc194th4ZVvra5xhvskBwkHGzOoX6Semyraworl65IWIttsyG/M9oCZ6VJ6wIEQwo1Pa3oX6oWqM08op0ifN7nfoa0AF7Vn2DM8qs87t3R1haqBH7Ledo2GPgJpZ+Z72roa9a2kiNHwVj6zjqByv/DUBm8vYSgDE7E4iwy8G652jEboTo5v/OWTa8apIRpTcxMaMf+8gh4tG1zISMtbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bm8uBxMxHoh2ru5fUipcuHWACEBf6mMjbYaMtPFkp3E=;
 b=OOyjyWmy9AWj2J4/ekmTgwV/qYgIMy6i1tD0KXkhn/JfgLZbf34nFma3eXX8ezG0TQ/vITPtmxxqzW7ckEdDKmkpU76i+pXMy+T/rrH/e8bPyHjMtAx3PwzRB5BR5w7ISrLMsc1hcEcwAbOHvxC9I/SSqwyTsJ7iBXyuAi/M6IkYim6U9Or9SXUQ+DyGABEr5g2RFjCSoFoMWWKbX+pnYZO7Cv+388BpeyEJJFe7X2lxQ2fKyNsYsNHuutpFlLR7YAS4wHAHk6YuBSpAJETQk69r9Ts17VOGS9nkxgTb02UE/g+4EK4jYU8rHJsrY31IjDhMFacqfqy2aPk1QMyIQg==
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:1d9::15)
 by AS8P251MB0088.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:34c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 01:06:37 +0000
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35]) by PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 01:06:37 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Jerome Pouiller <jerome.pouiller@silabs.com>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: wfx: validate MIB read length before copying to caller
Date: Tue,  8 Sep 2026 02:06:34 +0100
Message-ID:
 <PAXP251MB0010D011E3A1D007C14C54AAC8B12@PAXP251MB0010.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <4736844.8F6SAcFxjW@nb0018864>
References: <AS8P251MB00014841C19595C74C545C80C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <4736844.8F6SAcFxjW@nb0018864>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0066.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::17) To PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:1d9::15)
X-Microsoft-Original-Message-ID:
 <20260908010635.115152-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP251MB0010:EE_|AS8P251MB0088:EE_
X-MS-Office365-Filtering-Correlation-Id: e992251d-6d5a-4f3a-325d-08df0d456e8e
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|5072599009|37011999003|15080799012|8060799015|23021999003|25031999004|2604032031799003|19110799012|24021099003|55001999006|51005399006|3412199025|26104999009|440099028|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FcoWXvheFL1j9iyxHcGR8dmzI1WioyJLUurrmO83+h+c/c/D2hLvoewcn2e9?=
 =?us-ascii?Q?q2Mzv0hKrXCBBOCBL83vRFfWPPnxbMKYZa6UoBDl6F3BqF7uBhOXij/hxeaT?=
 =?us-ascii?Q?Atw9NhQqdixY72X1ISpP9xsYXlbAGGHKrvaiPinG4Zvz3CkW3YnzlhoIUH5y?=
 =?us-ascii?Q?iu6UWLcUefKYc63kdN4PQ/x6Q75TSFkXNe8WnrTuVjiGm6iUR1Hy3qhGptpl?=
 =?us-ascii?Q?/3tKu0HxLzX/v2jYGXYBjkRWG4AawwPhGN+tzACgUdxgJrcT2EUoIBErIZBp?=
 =?us-ascii?Q?sq2QsnpGbdGU2m5M1cftNaTPdJPWpg3J9wbQ1P4vH18Kzjoaa4enz0YT56gU?=
 =?us-ascii?Q?UNcM83aBp9JTLXAuQICSmjWC+i6cQeek72rK9ZcZ5FA3wdB8bBBuIW6/1rrW?=
 =?us-ascii?Q?oczqmxTohJjkkcDaDk/fQ+b6sd5Tn+Tk0YORKXiPKCmltemP6OdSIACx9hHE?=
 =?us-ascii?Q?+8RpYcF+sgG1kATBrXvpg2yFoBbIV7+nRkJmEpm0+XO2o5uX65qWpxuQlOwN?=
 =?us-ascii?Q?1jTxzDYYJjDvcxRZUh7Io3f8seE7SKJEmZk3tc/fl068IpBgfTizjxyVBQRU?=
 =?us-ascii?Q?AyM7Dn4iDo7gBEbO/wQwGity6wbTKq6Dijz6yF6cndUdKHmyaBDtO1508cDV?=
 =?us-ascii?Q?k8SN76BUSLAZ7s9EafFc9q6pLcenxryqKuRdVKc12aZ3WchQYigh5V+fP25s?=
 =?us-ascii?Q?eH8yFm+PFFmL/SO92UG7yfThx7VEg86bsfKaqKouiBjIH15auU3fvYDVhYCp?=
 =?us-ascii?Q?M9d7smCaKyVWFQJ0I2WcWXCvPc7gH3A/xK1WIRrzWI5pDr0mkZvXUYJZ2nxA?=
 =?us-ascii?Q?93HdebLRFZ8KNu6Ivg/gfWfmBCVtKEmUCde+YLhvb692SOADy8xZKiMs6zzo?=
 =?us-ascii?Q?EcDLk1Gvo450hUMH30dTwiDes6RFlxOdpHEu8p7kT9C+NvfLk7R/YyYgqD/i?=
 =?us-ascii?Q?JW+6ITDW5YeyjQwr0jiQAJtblfcmbNX49gRuTqY4NvrMNLsnngXZ9XRiZdjP?=
 =?us-ascii?Q?R2myZoLdvbJbzPM1DXvwXfUZfjh5/dhpzeW12xF3WUECkEo7cl2CCoImpn5v?=
 =?us-ascii?Q?NrFR9gmBwdk1bpqb4gXFbgsWqK797Fd5WkggIQ+LgPQuP0l+KzE=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rua+paJ8cm2VFfXVxHIWKkJJzuBzOinbBdI80wm1FIlVf+w4WvuvC/pvnYgj?=
 =?us-ascii?Q?FdZhHbmDytht8Hnm08C88yKbt4zvAJD2KrlO0aytY8sf3Y1jEcD8nUUZiZi7?=
 =?us-ascii?Q?mMAMFt9oI+jr8kaV1BhDI60QtefvIlMd/enbnUFFrn41gNXFHcBMZfroYmap?=
 =?us-ascii?Q?evwCq6U5FNq9tqRJ2gM3FQ9bya824yk6Ddy8RfdhlPwMhPtR2vacJF3O+ayo?=
 =?us-ascii?Q?TxKYsEJoko0SXU6sGGFLfnaJi/ibN2Jl1HePZ/eXIhqU7vtAfQuZEeNubwTu?=
 =?us-ascii?Q?pHNMIdwy2x536OeUKOy40wuuHFTDuXAf4CgeOO8+tuPEMnlG5hgRJyty/lHF?=
 =?us-ascii?Q?VqGAzw7QTKhyT7uh8QNvZEC4bJIv6JT/4vNVAFI9OZkW9BYP6M4bzA+k1Mwf?=
 =?us-ascii?Q?dskqL3vcNoP5P+h0CVbsIdX3gg1yPPjlCansO35qRjfT7mUhcoKs0oGKcN8J?=
 =?us-ascii?Q?O9nGWhb4oAXtvPmf62JFQkmHmMFS1ihEqboc+pGs8L2Piod+mINDJdmNs+I3?=
 =?us-ascii?Q?EZj5p/TPopgpLgYq20C/v/mNuJx+mPTfnQRDscZwFzSHzz1NAEPPMfki4PgF?=
 =?us-ascii?Q?VaIUCufvESwU75aCLFjgyx8oGZU95zBjKRAFv372HKFV5FhE/TIyHvBatBbF?=
 =?us-ascii?Q?BvjnUmdrdyiO1fVkKMbpQqBnVCZMb3S2QQ5tPY9sDKmUHkHnOQcnaWDAo26H?=
 =?us-ascii?Q?TsXk+beaL11H5GllxnMzdYnLJHzjuKA4a32rR4QNk2ssNTzDR5YkjBHbyD+G?=
 =?us-ascii?Q?CYyKccdiR2j6iaEqhhWa5VWoy5BlB1P0Ee/mhGqU7AZx1puYch7jy+mS/oRZ?=
 =?us-ascii?Q?Hi19LCpn+XnaR9XLSihZrdk1AkLdWxuJiVNZhPCWLQkwjNfSihgTz7Edwjfg?=
 =?us-ascii?Q?VW92csGXCd1FkGYgRdUW7VHg5ESvm8a6f1jyzIwq5v/Z7QiYnixLwBYm6Pzy?=
 =?us-ascii?Q?4OmqxDTBf5znsdQVnarCePvDWao5eXMQ+I9W80snionWcv3CcQn1SpqsSs7y?=
 =?us-ascii?Q?Nf808XYlknJ0kuPGP4/dBQZ9ZXGp7jUpeiZY6eIXvochYS2DIAQSFnsrFw6U?=
 =?us-ascii?Q?bv2KwSucf5zDrxAwKX6/Nd9KHUcMnOHIa9Jhon4/uUAQ7shrCEd0hL5xycs+?=
 =?us-ascii?Q?YIGuJKfBXRFv9PBww90SfuC9Jwr/q5Jejxc7+5MPZxaROYhYgoYtCos3FjkG?=
 =?us-ascii?Q?C6I74zqJtCtGKMKnIOTGrMLF7YPp/quJontshSoWx2Pbkl3wTaN42axOuvDa?=
 =?us-ascii?Q?M29cS0e8D8I6wMe5aZQcQxj92UWV3zEyBJgc24x/q1LuFJiW6y2aqYxY9YRD?=
 =?us-ascii?Q?KB0OAxKNgRqZg7LgJZ/jJcSQarj+boJrsywU9jE6nYtHMMBLjTnqacPxVrAc?=
 =?us-ascii?Q?x/FmSaCpnCksnJRHzK7So2T1y/GQ47U1W1XKFbiHnsdKNnXJ7Xz1DwJsy35E?=
 =?us-ascii?Q?VwmIzvsEdd8pw0QCkxm9IEPHf34pmkNi?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: e992251d-6d5a-4f3a-325d-08df0d456e8e
X-MS-Exchange-CrossTenant-AuthSource: PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 01:06:37.6493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P251MB0088

On Mon, Sep 07, 2026 at 05:36:20PM +0200, Jerome Pouiller wrote:
> Note you should add LKML in Cc: of all your patches (see [1]).

Will do, apologies for missing it.

> This kind of bug are typically spotted by AI agents. If you have used
> a such tool to discover/fix/review the issue, you are supposed to
> comply with [2].

Yes, an LLM-based tool was used and I missed the disclosure, sorry.
v2 will carry the Assisted-by: LLM tag.

> I believe -EIO would be more consistent. Otherwise, LGTM.

Ok, v2 will use -EIO.

While respinning I noticed the Fixes: tag points at the wrong commit -
9bca45f3d692 added the TX path, but wfx_hif_read_mib() came in with
f95a29d40782 ("staging: wfx: add HIF commands helpers"), so v2 will
reference that instead.

Kind Regards

Aamir A.

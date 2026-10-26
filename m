Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793024869;
	b=I5wwX3414/md54R8u57yiWE6crUKzwU0ff9a4v2ESzkP365oQFISL8Q5m+5eA4TLZHFl
	 IGE7xGKOUMH9H4e95yb1SoZ9s1BKjkdiGTmYXT138kPyY5oDVeFFYEzyPA5Kuak1k+Jy4
	 2s4e22SLGINlsZTr0uHJbRZtCUW2kPRGhRyu0TiuZw+u3+l6D3IxIFA+O3lz11rDaAx4h
	 uh4lK3eFraUxl6fKobUo39wz9ZL3rZdUPaXch2HY4MWhvh78b39mBLgNgYL9/naQR4lfe
	 XXfzvv8WT489NIkU+tKlSIeH3qoWcZGm8iuYNnOHNvde3ymB7Ia9NZooCdjoPS0CYqA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793024869;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-exchange-messagesentrepresentingtype:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=oCtWaNqe2keglXHX4QbcaQ0XIznbc9lImOa5XN45AMI=;
	b=ozRRzay6zxET+kUVfy99ua6X/RkbPG0DisacZ4OOB3k8R92BU0mRHJ4Th+qeuHR5Sj5d
	 JoCwUyIn0pmzef8vGU/Z+fvgMcnBu2K96Pi4701tfWuLHBrGNUkvF9HGoWTsLud0XFrXw
	 hiucEohixnHsHkUcinG5OOV+6TNtYN+0ty0f65i3LapRJCbSECLLVZ/yvLmhVa+KZW5Mx
	 ufLsICIsOlTH1zAGYO+TzRyGTM/jxo8j70+1u6Vw7jlFz8/IOcaJs7AmC7pmwGFf4E/Xv
	 QDF1om2/07zmcadCa34a8g/PsXqB7TD1MfNnuceDYHE+FR6dAKQ6yeJD4gimly0Kvdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=mj4xnSJT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.32
Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazolkn19011032.outbound.protection.outlook.com [52.103.43.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA81B606A326;
	Mon, 26 Oct 2026 14:27:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA81B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=mj4xnSJT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=twzxkRqbp/XxEKtRbpxIPzeQ2vOXngCmIMnqAFxg6uqSJukxSWevjwfAb+ZsIv+iFnY8RlYzIUecKJdcssypZFlnYjMkttdU0OqWJp9A7cxLA5HCZ2e0cnwalZor496ezQUhErImo9QO8T/srxpsxLdva/6rLqOy1HMBlWeS7yK7eAE+baOE6eoJWPj48jTJjC8PIRyC5MaX4wh1cZkKxJGf9kjYwEIJFodYAxC3FELVj1ap+nkl7ZnAT5YEcFTjWMpPrfF6BJRGwlf5eCEQOHyM8n7V2KOLtU/tQWtjtq9Ak0HqJcwc+2OkNDfd2cEOtcV0OTeo+JakeN2niEmQsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCtWaNqe2keglXHX4QbcaQ0XIznbc9lImOa5XN45AMI=;
 b=cko4HBV/MhyB7OHS630hJftIKxI1kUEm869ayRipo7ekv1sU1aXgBMwnk1ml4mST2w1zO1yafpU4ODjF2NqHPn5DP/l5NUDFsgUcMmeDiIN5iLoulPUcFdAX2AqoJhhrHCt7t/hFKYwwV+jcmo+1UV9SiOW5nJPaO5Gd5cm4x7KFifhalfJJrSDgxCUjOQ1ABqhxu6aZECGn3f/d/O2q9GdZNUY+1LVTj//bMqcoyji/vjC8Q/jo+yJmZ5IqCNMkLOOgxurV6jViLetkoPL95KsIn30phccW9zSCtKsuKfCRion6YewpBjD3ohreQcr+WACDxAkwHC9yhQt69uNrmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCtWaNqe2keglXHX4QbcaQ0XIznbc9lImOa5XN45AMI=;
 b=mj4xnSJT4KibCmOB8UnAQBgRO0dD55q2htQYMAwBZpeKc3KnY49mrlKLvKf++SQQlJShhWoCKlcb/nN/N/toWh3KbJ0gbM1O1/z7awcxQKPuTomLi3Ob4yBpUVKQpCcBfkpBNSDnunHMhPp8GU/MyQwd4V7wH+OLPOs1ImkoNUn8PqdO8uecFQ4CC0WLtt15rH+vOvhzIx0IXXGSGA0OipwoQcXD+Y/5RSeTztK8XMpGewJA60fue8HPJwoX7JkSzr7M2JJ8jGJaV6fbv5d6/QQHuB8/5AUMZYmUimJIwLKJK2emomfuCiGweBvI/idcckWGNW4rTVeZ46HZC6jbrw==
Received: from TYYPR01MB14245.jpnprd01.prod.outlook.com (2603:1096:405:19e::5)
 by TYWPR01MB8330.jpnprd01.prod.outlook.com (2603:1096:400:164::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 14:27:45 +0000
Received: from TYYPR01MB14245.jpnprd01.prod.outlook.com
 ([fe80::c970:13ab:a89f:6d85]) by TYYPR01MB14245.jpnprd01.prod.outlook.com
 ([fe80::c970:13ab:a89f:6d85%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 14:27:45 +0000
From: =?gb2312?B?0aYgt+M=?= <xuefeng64@outlook.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] wifi: wext: fix SIOCGIWESSID length handling in compat path
Thread-Topic: [PATCH] wifi: wext: fix SIOCGIWESSID length handling in compat
 path
Thread-Index: AQHdZVYiXR9pJi6A0UqPu3lIZpC1Ww==
Date: Mon, 26 Oct 2026 14:27:45 +0000
Message-ID:
 <TYYPR01MB1424583A97F1481EC603282D0BC612@TYYPR01MB14245.jpnprd01.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYYPR01MB14245:EE_|TYWPR01MB8330:EE_
x-ms-office365-filtering-correlation-id: ace1fb77-7b5a-471f-f3fb-08df336d4d70
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|15030799006|24071999003|39105399006|24021099003|20031999006|25031999004|25010399006|31061999003|8062599012|19110799012|12121999013|8060799015|4140399003|102099032|26104999009|3412199025|440099028|40105399003;
x-microsoft-antispam-message-info:
 =?gb2312?B?SnFDVDFPYy84dkQwRDdnNjVqTmxjWEpGVVhzSFkrSitHTVdmOGl2Qkt2LzVr?=
 =?gb2312?B?Z20zTzR4cEJDVkhZZHkxOEF4QjRBdFR1TTRmNkZNN1lpdEJoVEJjVTNIZjZw?=
 =?gb2312?B?VDJXQWdJUDRvVUpPQTVDVmdTY0hTSElqUHd4UUhwQ3pMQjBqS1B5aW9yK25X?=
 =?gb2312?B?dXlYRGVabXFTS0pwMVpNeGJiVW1LRk5GWVhNQW9remJQclovaVlYY2M1emJr?=
 =?gb2312?B?RnVqZG1ORGhnTlVYUFBMK3M4ZDNQL1Fsb0tzejl5TzhyYkVvVGpFMFdHdWZT?=
 =?gb2312?B?NnJ6c3BSbEQrUnpzY01PdHhTanlUUlE2Z0hubW4xeE9zNzE4MDFRV3dzcWJN?=
 =?gb2312?B?dXlZOG1EUmpDSXUxOTIvTVRqcU1MSGFwbVloNWRDMHVJQUNmdWk3dWZXcHd2?=
 =?gb2312?B?YmhyVGkvdGxsQXhKK2xIcE9ndW5neGprMlo4WnYxcjh4azNhQXg5cncwMVpl?=
 =?gb2312?B?d1U1MXdRMm90QUdwZm5pK1UrdU9nckdVUDUrZHlEZ1lTL1hsbE5GWjFWaHJC?=
 =?gb2312?B?aGdWblJrRFRVaTc0MjdzZWU3Z2R5MmVBeVBvZXZTR25Va3pqQXNIVFRVMk9l?=
 =?gb2312?B?cXFSVm5xbjdHY1Bzbms4dlNrakwyYit2SkJBUjZpYmFsUVNyNTVpRGN0WG9p?=
 =?gb2312?B?a0kyRGxjYi95Z05hVXo5V0VXN29LM240ZUdoMXRpSTRUOEc4SlV4d01yc0JC?=
 =?gb2312?B?M0ZGbHVOcDA5N2ZQKzlpRkh0aGFWdzdud0NkUWdVZmwzS2NVK1NpK0dGR3Zh?=
 =?gb2312?B?eFd0M0VWZElvc3FqVnE4VURUaC9JNWNPNzVJcEkrV2ZncTgvckNRNkdwaEov?=
 =?gb2312?B?YWpJMjN2YTJYT3VxdmlySkVTZURlV0Y5Z2NYeUFjbG1CZTZkaEZ1YjRITUVk?=
 =?gb2312?B?TXdUS2Z2UVVaeWNuZDRXL2N5ejVYaXFNcjJqbjB6RDRLelIzOURjcllZcVo3?=
 =?gb2312?B?aEUxb3ljK21VMWNyRXRZQmx2NFc4MkRaNFlSNnRvZEZ1QldOTmd4WDJHdGpv?=
 =?gb2312?B?cWZPc21WeTY3THR1dGYrVFZOUmhUSHJRcWNVTENuYUZvS0xvcUtRc1JpZUVJ?=
 =?gb2312?B?amVIUStZaUdxaVdFS1U2WHJRc2ZCcTdRd1g3WnJEbXBWN1RNOVM1MzFVd0lF?=
 =?gb2312?B?blBPNFgyRWZvbEUwbXFYYmgvNk9JTG5JcElWM3FUWExLdm5IbzNZTXFQV0l1?=
 =?gb2312?B?WjBBVnA4dGQyK3d1YmJoRkZzOXVYdXpvMUNFUEgvSVl5UVl0ZkJGMWhmV0lp?=
 =?gb2312?B?U1NURUJkZW0wVzJWek91d1l2ODljYTVLZ3NWNkd2Sk1wNmtybVN0cHhRYWlx?=
 =?gb2312?B?UUtTQXpBbDJwRDhRQm9SeFZ2WFhvZFlLT0Q1bUFtUDdYUy9jN3ZSQXpNa1pq?=
 =?gb2312?B?Z0JWYlk4TXVnWGp2TWNCcTAxb2cyRWcrSjhkSlQ5ZEFNY0xmNUcrdklWdG0z?=
 =?gb2312?B?NlJPbzQ2WGpSMWhmT2xIT0tvUVFjM20vbkluZDVsUGZHKzZYK1RkRVI4aW8x?=
 =?gb2312?Q?IhweZg=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?N29PQ3pSZUl6UFUrSWJEMXhEN0gvOU5ncmU2UU96TGgzdkJrVXQ1MGFoU3hM?=
 =?gb2312?B?dXFjZDJJVktQVnVNZksxWVdjUXV5eW5Od2NGOC9YQWdQbG9idllUTFlrS0dU?=
 =?gb2312?B?VU5RbGppZm9sSEtmRE01OVdrSzM2Y08waUdNNS84bWNqNkNveFhWWm5vQ01T?=
 =?gb2312?B?MFp3Q0JHOXZyenpDMnhDTUxHS0JzVXJvNUNoM1RjNXJNTDRSL0lKTkZsWndV?=
 =?gb2312?B?STc5VnhNTlhzTDBEL1JXMUlFYXpRTkVhQ3h0TThFcG1DQzRuZVRaRFpadjE0?=
 =?gb2312?B?RisvdzVyR0hvNnJ4c1JtWTFIeVA0Ykg0VzA2S1I1UkVIWk0za0JueXp6MDFF?=
 =?gb2312?B?M09ISXZqdCtnWWhXTERVSTBmTldLSFBOSjRTY1hqK1RiSlRzKzU4UVRjRmpT?=
 =?gb2312?B?Ukl5dHN4RU03ZVBnbFYvNE1WMlF5Wmc4cFFxL1VXSm9LWi9zNnZpRHRTdnVt?=
 =?gb2312?B?VkZ1TFZHZFR1NkFMdFNVSUtqRU16azJVZjdUMS9qZEVJUkdNNTBUZkFSeVl6?=
 =?gb2312?B?dHlHYzhNT0dKVDAxRyt6WHgvYWxVYjBtbWx5dU5ZZHN3a1JxUzJmVXlHQUVk?=
 =?gb2312?B?V0FlQ3EzMFBqc0hLZGQyNFVaWWFCRGV2cnRXem1sMzdxRGJwUlcxb1J2REpy?=
 =?gb2312?B?T2M1UXljdDl2V2hkTEh5YzZkS3o2aGZZdklhU2owREllcXNsdkQvTlZUUDdQ?=
 =?gb2312?B?UEhXRnJDTUhrWXFab0wxdVljWStwUHZRQU1QZDh4QjVwb3N4NVRyTmxTYitS?=
 =?gb2312?B?aVNCbEV2eEMwTW1lVzdTcWlsckJ3OG1OK2NodEdaWERSdkdPa2loRVRZMS9H?=
 =?gb2312?B?OGxydXZ2ajYvWmxpNzFyVGhTRnFSMU01WDNDUHFlYStxU1lUVlJzZ3d6dyti?=
 =?gb2312?B?dWpZUDBZc0VMb2JvZTJDVURhMytnZDYyMml0S21ReWhNazFNU3VKbDU5Q1g3?=
 =?gb2312?B?aXIvTzUyQnF1ZldMM0o2VVpReWFoYkdQbVRxK1g1RTF0WW9OVG9DTEQ5Q1Z1?=
 =?gb2312?B?Z3RBaGtVcHB6cGJXS0tkQjZTK3lzeE1oemJlNjhMcmFvaHRMMEtLdkZuUkh4?=
 =?gb2312?B?azhocTlXOWQ4TTA5Y05hOUZadmoyOUNXV1lENG9Wd25FTTlmS3NjTHFCYjcw?=
 =?gb2312?B?M2pzZU1OVGFCVXoyVm1WM3BudWhEanU1NTFxa3l0b0RkM3dQMXpQM3o5UzRB?=
 =?gb2312?B?QlNzZ281eVA0KzU3RTJlbUQ3aWNPTWR5RC9Ed0E3SFlucGovK1MwVkNiZklC?=
 =?gb2312?B?VXBrZGtyYWUvWElKMmN4V2hqZXRxOXpTTHpwY3VDL0FIbDAzNm10WGJIeXlD?=
 =?gb2312?B?U3ViRHQ0MWF3bjE1RHRzUmpHM0NWaXJ5OXFiVUJiV2dSQzhESHBVcnY2TWxz?=
 =?gb2312?B?czgwYjdhWnBNVnB0SG5mTUNYWTEyL0RNNjc0RFFQSTFrS083a0luajdLNTZO?=
 =?gb2312?B?cmgrOVVqeS8ySS9nMTdSN3JzR3dJbGR1SStqWWF2b0dOcVJsRHdYb0VXaFhH?=
 =?gb2312?B?bk5yZURpSHlTTlVackg4cE1xSnN0YzBVVW1RNk5MUzFHMzhONksvMUdDT0VK?=
 =?gb2312?B?L0luaG00eUR5QzExNnB5Q2d4cHErNWZhZm5CbHV5ditBNmxDVHF0SWxha285?=
 =?gb2312?B?ZWZrcmZuYkhhV1Y0VElrbjdRY1ZrNmFsUHhQUGdrM1VMZjlLOG1sUlY3bHpK?=
 =?gb2312?B?RmRpcHIvZll1ejM2U0xDWDNKcDErL2hRY2thS3JEWE90Qk5xSWFUa2RXb0FE?=
 =?gb2312?B?bE9lWXBGNUw5MDJzTmZ0aldMOEtsZzJ6V0dPc0s5Q3NnVndVNGoyK0Y0ZkJz?=
 =?gb2312?Q?voA1seyKuVvsQMHvAcWQUMT57AQyMG9JqESu8=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB14245.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ace1fb77-7b5a-471f-f3fb-08df336d4d70
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2026 14:27:45.3319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB8330

RnJvbTogWHVlZmVuZyA8eHVlZmVuZzY0QG91dGxvb2suY29tPgpEYXRlOiBNb24sIDI2IE9jdCAy
MDI2IDIyOjA3OjQwICswODAwClN1YmplY3Q6IFtQQVRDSF0gd2lmaTogd2V4dDogZml4IFNJT0NH
SVdFU1NJRCBsZW5ndGggaGFuZGxpbmcgaW4gY29tcGF0IHBhdGgKCldpcmVsZXNzIEV4dGVuc2lv
bnMgdXNlcnNwYWNlIG9sZGVyIHRoYW4gV0UgMjEgcGFzc2VzIGl3cC0+bGVuZ3RoIGFzCklXX0VT
U0lEX01BWF9TSVpFICsgMSBmb3IgU0lPQ0dJV0VTU0lELCBiZWNhdXNlIGl0cyBidWZmZXIgaGFz
IHJvb20gZm9yCnRoZSB0cmFpbGluZyBOVUwuICBpb2N0bF9zdGFuZGFyZF9pd19wb2ludCgpIG5v
dGljZXMgdGhhdCBhbmQgc2V0cwplc3NpZF9jb21wYXQsIHRoZW4gdW5jb25kaXRpb25hbGx5IGRv
ZXMKCglpd3AtPmxlbmd0aCAtPSBlc3NpZF9jb21wYXQ7Cgpmb3IgYm90aCBkaXJlY3Rpb25zLiAg
VGhpcyBpcyByaWdodCBmb3IgU0VULCB3aGVyZSB0aGUgaGFuZGxlciBoYXMgdG8gc2VlCnRoZSBs
b2dpY2FsIEVTU0lEIGxlbmd0aCB3aXRob3V0IHRoZSBOVUwsIGJ1dCB3cm9uZyBmb3IgR0VUOiB0
aGVyZQppd3AtPmxlbmd0aCBpcyB0aGUgcGh5c2ljYWwgc2l6ZSBvZiB0aGUgdXNlcnNwYWNlIGJ1
ZmZlciwgYW5kIGl0IGlzIHNhdmVkCmludG8gdXNlcl9sZW5ndGggYmVmb3JlIGJlaW5nIHJlcGxh
Y2VkIGJ5IG1heF90b2tlbnMuICBTaHJpbmtpbmcgaXQgbWFrZXMKdXNlcl9sZW5ndGggb25lIHRv
a2VuIHRvbyBzbWFsbCwgc28gYSBmdWxsIGxlbmd0aCAzMiBieXRlIFNTSUQgZmFpbHMgdGhlCgoJ
aWYgKHVzZXJfbGVuZ3RoIDwgaXdwLT5sZW5ndGgpCgpjaGVjayBhZnRlciB0aGUgaGFuZGxlciBy
YW4gYW5kIHRoZSBpb2N0bCByZXR1cm5zIC1FMkJJRy4gIE9uIHRvcCBvZiB0aGF0LApleHRyYSBp
cyBhbGxvY2F0ZWQgZnJvbSBtYXhfdG9rZW5zIGFsb25lIHdoaWxlIGNvcHlfdG9fdXNlcigpIGFm
dGVyd2FyZHMKY29waWVzIG1heF90b2tlbnMgKyAxIHRva2VucywgaS5lLiBvbmUgYnl0ZSBwYXN0
IHRoZSBlbmQgb2YgdGhlCmFsbG9jYXRpb24uCgpBcHBseSB0aGUgY29tcGF0IGFkanVzdG1lbnQg
b25seSBmb3IgU0VULiAgRm9yIEdFVCBrZWVwIGl3cC0+bGVuZ3RoIGFzIGlzCnNvIHVzZXJfbGVu
Z3RoIHN0YXlzIHRoZSByZWFsIGJ1ZmZlciBzaXplLCBhbmQgZ3JvdyBleHRyYV9zaXplIGJ5IG9u
ZQp0b2tlbiB0byBtYWtlIHJvb20gZm9yIHRoZSBOVUwgdGhhdCBsZWdhY3kgdXNlcnNwYWNlIGV4
cGVjdHM7IGt6YWxsb2MoKQphbHJlYWR5IHplcm8gZmlsbHMgaXQuCgpTaWduZWQtb2ZmLWJ5OiBY
dWVmZW5nIDx4dWVmZW5nNjRAb3V0bG9vay5jb20+Ci0tLQogbmV0L3dpcmVsZXNzL3dleHQtY29y
ZS5jIHwgMTQgKysrKysrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCsp
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L3dpcmVsZXNzL3dleHQtY29yZS5jIGIv
bmV0L3dpcmVsZXNzL3dleHQtY29yZS5jCi0tLSBhL25ldC93aXJlbGVzcy93ZXh0LWNvcmUuYwor
KysgYi9uZXQvd2lyZWxlc3Mvd2V4dC1jb3JlLmMKQEAgLTc3Nyw3ICs3NzcsMTkgQEAgc3RhdGlj
IGludCBpb2N0bF9zdGFuZGFyZF9pd19wb2ludChzdHJ1Y3QgaXdfcG9pbnQgKml3cCwgdW5zaWdu
ZWQgaW50IGNtZCwKIAlicmVhazsKIAl9CiAKLQlpd3AtPmxlbmd0aCAtPSBlc3NpZF9jb21wYXQ7
CisJLyogRVNTSUQgY29tcGF0IGFkanVzdG1lbnQ6CisJICogU0VUOiBzdWJ0cmFjdCBjb21wYXQg
c28gaGFuZGxlciBzZWVzIGxvZ2ljYWwgbGVuZ3RoCisJICogICAgICB3aXRob3V0IHRyYWlsaW5n
IE5VTC4KKwkgKiBHRVQ6IGxlYXZlIGl3cC0+bGVuZ3RoIHVudG91Y2hlZDsgaXQgaXMgdGhlIHBo
eXNpY2FsCisJICogICAgICB1c2VyIGJ1ZmZlciBzaXplIGFuZCBlcXVhbHMgdXNlcl9sZW5ndGgg
Zm9yIGNvcHkgY2hlY2suCisJICogICAgICBHcm93IGV4dHJhX3NpemUgYnkgb25lIHRva2VuIHNv
IGt6YWxsb2MoKSB6ZXJvLWZpbGxzCisJICogICAgICB0aGUgdHJhaWxpbmcgTlVMIHRoYXQgb2xk
IFdFIGV4cGVjdHMuCisJICovCisJaWYgKElXX0lTX1NFVChjbWQpKQorCQlpd3AtPmxlbmd0aCAt
PSBlc3NpZF9jb21wYXQ7CisKKwlpZiAoZXNzaWRfY29tcGF0ICYmIElXX0lTX0dFVChjbWQpKQor
CQlleHRyYV9zaXplICs9IGRlc2NyLT50b2tlbl9zaXplOwogCiAJLyogQ2hlY2sgd2hhdCB1c2Vy
IHNwYWNlIGlzIGdpdmluZyB1cyAqLwogCWlmIChJV19JU19TRVQoY21kKSkgewo=

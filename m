Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010002.outbound.protection.outlook.com [52.103.33.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CFB40F749;
	Mon, 14 Sep 2026 08:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375453; cv=fail; b=Uq6sjLwt3YimJmvEAi/yHb9LRc9d93ZGgVt6/aI3CQGIwIWGQC+FBGNj5Cle6BKmhdX3+kjm1hUsOxDBwFls1bxh5bog1mDY0m8blChlXCuG+5tiicvvca6JgOuLkNwQelFWpcR+heDlokFhyCjrExRnXO3gNglhYYAmDYhFGEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375453; c=relaxed/simple;
	bh=jD8wVGCdPLmethOaCGKPlc6IFF1FhqCUF1ARIAVSEx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gYEyRe1vNj4OxWWhohNwliz6DVeIcaew/KXQI1m5RAbR3j3JD9ww/ijkXhEefFxqWLqROzlQ8H/yjdOzMQSPegetM/lI602nUOBvR4kMeeOx5lmbg/AUPUAYiFx/fqt6n2sdbeysajtYW8xdl0L3y0azokvjPLMmmjkiG+EGlxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=KfY254xi; arc=fail smtp.client-ip=52.103.33.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="KfY254xi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rEzw7hPcqXf4u3yhC47+SBCu8O2cDAPYY7/PdjYLAqjVlukcvnmCsdlTkC/vws7TqWE6/YEwTU5Vt5Z4rvGhfo7poWhTQ97b/4nJTsn8CaDqDqc6n64lIRMCg0ReZTXQ8/MGlJOl1ppE28Hg49/ZgqIOH+6IqqfNcuqg1QLkbx5wQDd16lKygRVy/K9cmpaNGmrzYytjPIMLcOhYMh0k+N2ELnsIfLQqrosrFyWw7egooo6Vq+27TUX1xZaJUEqYbZb6O0S7dDgK3IzW7/nuqzCs1xOwgQdi9QscsgJ+tBVKnEYmd2Q64gtOTVtTkTD9zttzVkIXHJKIU0HRKclOKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwSB9jJbHQbsmREeNL2ytwu4ClTDXo99GyO1xIDEFW4=;
 b=g8c2iNRzcFF9gG0jQm1Xnwx787nLTt5FbwNJgwNdajvIEGCHeebinmAa84enrnoazoM9YNC2sgEXxnBqYniTGpm9bfM3dhZ0sRB+MUWJIwAh5YD9FYmKOdCSGkekxi4ccYkl+2ipHayXLpc8slR2dLaXnMRuu0cVns6mpW7FCd/Eqw5uEElOucMIePSFOSCW8EGOUL2oePpzAYCH7dAy2guFRdglPWNI9UYpzrj/x7gxDJvllElaeni7I1hPbtCmf+AGyydwADRYbLDQJWiw7bjXe2EnQqFB3wJAYPnIryWRF9l+//IVyK8jmNXqqQ8lgETaLN809WlEZlYpwJfjeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwSB9jJbHQbsmREeNL2ytwu4ClTDXo99GyO1xIDEFW4=;
 b=KfY254xiyqr1e9sz37zMZsC/fPDPrPoJMfixFn2fe+CeZ5XNc0nPoT20vEL2kPgWuQYYeegrdwVk89fcgIm7R6lzkfIeaN7qQ+i6kFmThNQuAhiVmXhttzCJhHDpL9dWYNum/zc5L3L4eJqxgqZ1xritN1V8dk8GdOzKXixjSIFP1CjGQEwl4FEMhARc/JVSYMSNHTLNuTkXtxEYrJos48KWZPr46CmeF4ib3mhkqu+sG3L3tDlIbDQO0Y/ghvLZ5UNKov3Aw+oO0FzadoRPiz4qvUZLjXT7mswLxPX9JLIh41Fr60wXzSyDxEDKhuvhlZWfqQ5D+JnCobCJty7Mug==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PAXP251MB0550.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:286::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Mon, 14 Sep
 2026 08:44:02 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:44:02 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Jeff Chen <chunfan.chen@gmail.com>
Cc: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next v2] wifi: nxpwifi: validate variable IE lengths in beacon parser
Date: Mon, 14 Sep 2026 09:44:00 +0100
Message-ID:
 <AS8P251MB000168807E4D761BF4F19170C8BB2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqet/hLbBlBpj3Xa@nxpwireless-Inspiron-14-Plus-7440>
References: <AS8P251MB00010E2945A1BE91EB5415F7C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <aqet/hLbBlBpj3Xa@nxpwireless-Inspiron-14-Plus-7440>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0406.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::15) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260914084400.93185-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PAXP251MB0550:EE_
X-MS-Office365-Filtering-Correlation-Id: 0984a23c-712b-4b8e-0225-08df123c5392
X-MS-Exchange-SLBlob-MailProps:
	WaIXnCbdHrO+2YmbT5jW+WUSUt4IT5vRvarHrUZWmCJV1cbLah6vNuyFxfmM2vx2Vy2Ceqt1o9yZDLwisAuSCxjoH3MQlZCvzae6HFNawDvmDvmrXHDahn2autPAf9G5RITMc6Xg8CNIKeQ+JQA/Jouj1k5yyflKwgob5prp9H2XdbEozTvds4dgkboZ4Sj8j9kbQhqgn7BI0aYKFH/Trdx4VsqYm1+MgiIY3ytFmTVxjzBhrNobGjK0vHtuSGIE8+7DBszggW7QofefEmaeqg0irNc8z9z5Kj/O7UXCBHPiQbQPOhJ6J2e5C/2x3DnP08/2HKDTp3ElFJbe1DwmNG28AAncr71tyO2glUOHBir2FGvLd4bFslRzgz7z47y1fpP260CxNEQJcRVE3tjraeXlywxHzPAuu0BkuDvRrUZpJ0I3ER3AovrKCKY8I6Rdk8UftnTWOfDS0ohPrwhtmT3YuYYHXPTK7FHO5RX9OoK7wGlUGZYWe4jn+pBZy0NIyfOxXeIm6Jy+P3InFSI/Z//xo20QxQkf2uYtgLUOq/kx2XSqHh6hzsN8clAq9MZYOFOTKe5oNMubtDAjbJmLRGH/m+V53CCm3lhuudpuctxY1aOBjdmwyuocOfuSDwFXNe/NGn6mBiKycVZVgkaTCvY7nyLUtzIQfBNXggeVmh8+wtLDUR6rDSvZ/M7EMXYEf2Ax+dgx2k8/To2OumYHq4q489ahRCIu6XKyquCSNhao0+o8tFv3FOJLQFCz0el55jKUmbuC7pE=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|5072599009|25010399006|23021999003|8060799015|15080799012|12121999013|19110799012|55001999006|24021099003|37011999003|25031999004|51005399006|3412199025|440099028|26104999009|40105399003|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EowBGWGl50x5fuiMGrWBJr7D3F5x/XfGnVbBxwRfiKE8IGoFCF49KZS+UnUF?=
 =?us-ascii?Q?bnT+2RI5cJTYeLVYOe8+Krs77QIZ3dZR1ma1+XrSyefPHS9voAma3FWlJ27C?=
 =?us-ascii?Q?PZJU4UyErMtVZr2GqJvKIzJgE8f2dBIpag73Mnjm1RCd+chVyZAqT8jY/p7p?=
 =?us-ascii?Q?je3Nkd6lFuyL8vXsylGnHa3Lm9Ai/wIQyo6Ofn2+kH6Y0MwrNmPGqNL3BmEA?=
 =?us-ascii?Q?V7WOl0eX88/InPdgFj3WK+v69SjDK2PivMoRR1qk+Ra5Rffemyir6DsngIIe?=
 =?us-ascii?Q?pQcNYJwgo8lymRpH7WKYP//2xEKO56V6Uw75znKOSnXGpGYZ94YuTc9MGM+s?=
 =?us-ascii?Q?vyVh7whp3xUSvBBuw2M7gLzAHw5rELJ4WLxlCtbMQqeVZdJShJQNqYbyd5xL?=
 =?us-ascii?Q?Y085XPDWyIcF+4SfzwdM1mphuC8e0zuS/OfBkbcABCIXFVVViF5xjxqJLZfb?=
 =?us-ascii?Q?u3sHAOSS9djMLm7U4bWW+t/v5SOdWfB0m8c370MojlyTaD2nvEDCVyGvkj8V?=
 =?us-ascii?Q?RqcC+7tOdMNnMos3NMuqzg7mxy63uhXJ+n+qJK3y0ExTEuO+KgJHTzsO83nN?=
 =?us-ascii?Q?9z2VS9nvKf1w3ijs5wOHNNi9efys7oq1rlYI4LVYAWIHW7uvXy8swRS8IqLw?=
 =?us-ascii?Q?lNaGA+a2xPBsGzdKUYNUGXTbq18PNDtW54g5MlBPCMTGPBADkZlLxjEea0Bj?=
 =?us-ascii?Q?yOR13e8c0eKlcI+Vibo54Tlw+6bTFXUIHZ2W7LLhNPLv7/A1LYYiC6tW2qof?=
 =?us-ascii?Q?7YSmPt1awTCvUlvUSIN4SvOVCJObMx8Zq6OUksXlAX6j5vMMBWuiqd9+k4r8?=
 =?us-ascii?Q?ArjlCudbJDUkyfQhYnrla4/4BNZ8DhDWzIIxQnDaPAFK8y4Dz+TfpGYLfY2Q?=
 =?us-ascii?Q?nczMyeL0Bjgl7KpdkduUGJxK/oC0EjXCWwbFt4gD1oz7IswlgH6vyK0102BN?=
 =?us-ascii?Q?Rduvcrn+PYIy/oyvr9IZnCsvsLrqC0ecbBNlelt22JN7A4lYNyfq7HychTtH?=
 =?us-ascii?Q?l3+C7oqlZx3WJZpBnBMxnMrNbpunp3LXByAq0yjl4sY0jb3R1EQHwpfo1uL9?=
 =?us-ascii?Q?ceWuc5XyU8CazFFek0l0L8WSLlqOETHnLvOrLa38n+XHmF1QKMY=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z/+AHGmgqyhMY7OI6Y1KKqY+mdvnFSnYcXKCZ0qsYoagTWeIrCmTXCQMnBsO?=
 =?us-ascii?Q?SClT9dFWOZVU8Io4SN7Yoe4a6AsZVKLK+stF35eTpH3EoG575CO3d8lJEVzH?=
 =?us-ascii?Q?p6s0SW8nh0p70dIDw+yVtfmUINBu6f1hscodyoR560XTrR5NrftH4y7/8lvj?=
 =?us-ascii?Q?PAe/iZVgc4GdU+RUBqzxVCO418ooGcD3xfG177Oar8d4cI8pjlwJBkn+1WSw?=
 =?us-ascii?Q?Bvs8aRlod9+xRdM9Pv+IqRGc/xhJbZrrFBlWYvd+zORmfgp+wI06mAx1QIrn?=
 =?us-ascii?Q?0sSO6xXQpnDBp+J2kcpOhBK/6LM0hpMw5La1yStAtnAXtLcihIj2aM0Xb8F+?=
 =?us-ascii?Q?WvHMFlnsKllHVHx+0R73gpQS5XNYnw9vKLTzpQZzn9EW91HizZy9w7sb/7p+?=
 =?us-ascii?Q?Zrp1funOMyegzKibPNSTBuJVcIxvEUPqgt7cJFZIX6+UaPzwKh9MsTaQhhge?=
 =?us-ascii?Q?IVon1y9Yh0xbD5l2fwhnVTl1VOd644szNd689tk/yEy2VKt/r66yYEV0BnGg?=
 =?us-ascii?Q?ItPgbbDIgsrkhHSKnfR6C0NRWySTeJ4ORMIVqw47Tb1ycBC/kb5GzB3j7waZ?=
 =?us-ascii?Q?eyt3BpzjLBM1GBiEyBu0vlvj0NYzdqOkG6g1gWFyQ2ZL+IuSAIn5HFBy/qe4?=
 =?us-ascii?Q?GxXWZDCrCXj6WcF/BINQ7AlS7/KzgBiNt9vbXcCt4jv0IyjgNAyI3v8oDhwJ?=
 =?us-ascii?Q?3XQ6RaOXawbdsMxssthSiYHGJFe+AazOxBvMNYL+4qSze2XWXcl6IFP++r0A?=
 =?us-ascii?Q?EPOko9e5EbbpSPDsKEEd5tV7lee8YpmMharQvGxHVkPTKfCyWf8ITjDUI4/5?=
 =?us-ascii?Q?Rqk5+WV8v0FqwFQKWI1FPCtcAdBpZKzAnmGlc8k4dfSK++NrFfGG7FiDsSi7?=
 =?us-ascii?Q?OZ6k0RixcSDeRVgR/C/WiZsj3pZwPCSOgDB3Fv1sB99sWou5PHCvby8kUpKu?=
 =?us-ascii?Q?FJ6CtltVG1+B/MJmr41vUTVC773yArZXazojeNDv+VNt3J+zb6ndLcyNCTYE?=
 =?us-ascii?Q?CxaWgcWDnP0spYNRMv+nEPT75C0G1lORKwMNosSPS3LMWWYb95Rpd8On183Y?=
 =?us-ascii?Q?OK0yaoOXfkRNTZxb+TjTg8jTYwgovzcoDh0bbiLniQrTIBUMK1ZdlHeHJBy9?=
 =?us-ascii?Q?E1OTe8Ggux8lK/sitLhj+vna8ajfkZ31ZFS4iU94ucSMfK9Hora5ZlC5b2F6?=
 =?us-ascii?Q?f9RyJ0z1ifhlysi3KLd/NSvEszkcx8GXmCw3/hbqTfIWuciY5RO9Wv5qmLne?=
 =?us-ascii?Q?9YuSkDDcKOVmHyr8rQ8tI2QJ0uuiGKQ5P8D6caobiIgkCSJSsRAtRn/uMmLu?=
 =?us-ascii?Q?BkNne1KHiA/a7nrFLJN8qxxCO456bCaLSmvSTTMIVzd2awVldU8QOSTrNnnJ?=
 =?us-ascii?Q?h1T3TTM58HnPk9lx2UoNtyBRzBIYNELDpm9mEXZOQ1pSAhsnhNu+QgFC1QbZ?=
 =?us-ascii?Q?44IV2FqoEnpCSZ+h22GfpkhPx8SGLCEE?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0984a23c-712b-4b8e-0225-08df123c5392
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 08:44:02.3719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP251MB0550

On Mon, Sep 14, 2026 at 04:19:10PM +0800, Jeff Chen wrote:
> On Sat, Sep 12, 2026 at 05:20:31 PM +0100, Aamir Ahmed wrote:
> >  		case WLAN_EID_OPMODE_NOTIF:
> > +			if (total_ie_len < sizeof(*bss_entry->oper_mode))
> > +				return -EINVAL;
> >  			bss_entry->oper_mode = (void *)current_ptr;
> >  			bss_entry->oper_mode_offset =
> >  				(u16)(current_ptr - bss_entry->beacon_buf);
>
> Any reason to use total_ie_len here instead of element_len?
> Since we only access oper_mode->oper_mode later, would
> 	element_len < sizeof(bss_entry->oper_mode->oper_mode)
> also work here?

Yes, I used total_ie_len to match the FH, DS and CF parameter set
cases, which also map the struct from the element header and check
total_ie_len against the whole struct.

> The current check looks fine to me.
>
> Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>

Thanks for the review.

Kind Regards

Aamir A.

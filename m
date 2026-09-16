Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazolkn19013079.outbound.protection.outlook.com [52.103.51.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079194D6C25;
	Wed, 16 Sep 2026 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.51.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583886; cv=fail; b=uAmGeqaPln7qflBEjSQA9ZXCm3D97/VY5o+H2m/GNji+0Ayj2WUEzsx1EomKmOzXJSaYsLuQ2gYNsJnrTevzJbRqR/d1mMqMwmF6jAslDf0aZeTLEqctt4M7rDPGcN2BtbnhGyYZU3GaGuonrpGkNlPz/0qLYODSJ4Fd/OgSWFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583886; c=relaxed/simple;
	bh=XVmYLThRV8EZ/wLiZNlgSa/PzzcKDH6hbH1okwkv8Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g7v+aZ6gpwRDcbJop6HK2TGKyyZmBSZ4I5CKhWAuvGDGjY1stcLKD4SWFYAAZX8Ad6h2IWOyOPPAOzpD3LmY/D0I+3tn7ylKSx9QZUNwAPFDXcHUMnfZ2HO0xaEP1tJ8rGOOw21djn67LajsG84iN1nSj5oGHned0ND5ecQmhlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=bwQuhdGL; arc=fail smtp.client-ip=52.103.51.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="bwQuhdGL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DOLlm/EdhZYeCsg3T5v6rYe514YtfR1x+KX/eWCxfisUlVE1BTzfJG+4qZJMFxCoTkRJq6/nD5iQuiYeB9k4ulyzwgee5TQ201GmFi2RXV7DJUflynn3/nVRV/fuQcloyHg7ay8ng6Gzpa/8OiWu8DaIRhcJLzuvdClYJzHH1n87dmXp5V8kAdKiDEyBVWcx5dc60xX979xMveJWwGN24ETcya2qPCkV7Et2u7eNqLBHvArSVj5Jd9ZopO1kla4i+jquwO7F6nJG1E3xB4l5q+/TOes64g19yq6//QzkMJa7ztiMIVNlNvGV2jywX48A0nazYCEK+QY3zcE92KcQAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVmYLThRV8EZ/wLiZNlgSa/PzzcKDH6hbH1okwkv8Rs=;
 b=oZ9w5+kjXUvF+m0WwQoQMr0OjRW48ekHTdFZ23XoijRaBUspY8ZJVsbflf3UApstHJG1TLFoQolnfzigkcvsvd1cY/Kl2Oku56ReMyWwArtnO/6eTZyvRta2deaVsloOsd+C5Nhlrm73yjid/FUWfnCZPEx9K58Je5E/NkTq4Ih/4IFux+gWbI+VWwr5ppUFw1dQI7M+l5Puigy5ttVEqLRdHt5rfwtQ+Q8/vIEIKU/WFdX+ecFBohZRv77IWyQxBHJpaCJ2YUya2VAgBK7uzDRT1XCVRPjNX8JqCm/siKpxHRaLKlK55nxf7XJ0+bG0mSqaEoMmHqQQBxZigldb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVmYLThRV8EZ/wLiZNlgSa/PzzcKDH6hbH1okwkv8Rs=;
 b=bwQuhdGLy8lDqr9t0SWKlmo64udhXN837etAnno5a8jHFR80zbxeN089+da7LheSdpxyrIcJulPXcDAEKmrUiWb8fYgShbvWHelrV+PePrXZC2wLIxShnfPVkJb9OTopHChkm9RNAdSoRQTjZF0Klhy6Kt4P7GmaUa3gEfdUrUdH47Gp3rOFpblMDgPzGtSlBrUzLJgBtZQDcU1sKpDrdn6M1DXl9GAoqHBnXd1IREUjqVwLilwUI+Ffv1z6EXc3yMpsi9mUJIYOYSNJpivK2VrEPeCGp+LZ3bpz5RrgoxDBzm/HzsxmTizquvWMmmTVt8XZro4xqOLBdeyIKwB0cA==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by GV1P251MB0795.EURP251.PROD.OUTLOOK.COM (2603:10a6:150:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 18:37:23 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 18:37:23 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless v2] wifi: wfx: validate MIB read length before copying to caller
Date: Wed, 16 Sep 2026 19:37:20 +0100
Message-ID:
 <AS8P251MB00014D0DDFBEADF55F743E0AC8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <3635048.QJadu78ljV@nb0018864>
References: <AS8P251MB000155034FC391A2A54B9803C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <3635048.QJadu78ljV@nb0018864>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0401.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::10) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260916183720.2867-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|GV1P251MB0795:EE_
X-MS-Office365-Filtering-Correlation-Id: fd5aba19-ad7d-4c2c-46ff-08df14218c77
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|37011999003|8060799015|25010399006|51005399006|19110799012|15080799012|25031999004|6090799003|5072599009|23021999003|24021099003|55001999006|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yi9ndlBwWnRLREtKaHJobGtObG5GaDZMaWNoamt0SnBSaGhCVmU3WXpqOE5R?=
 =?utf-8?B?UmMvNEhob1BHUVdYbVBTNm1WMnZNYml2MFBoRGVQLzgwSlpQR2tHRFpuK3gy?=
 =?utf-8?B?UEFXazVzZkduYXk4aUdoUURmbnJRR3NvaElqRHdSemx1UUhGTEZYaDlLVVYz?=
 =?utf-8?B?SHV0R0FzVmsrTjBmQjdobWVNa0IyNUcwU0hqYXc3bjZiV2JQNzVPNVRHOXhD?=
 =?utf-8?B?N05tOUpHN3MvNGxrS1lxY0hTQzUrT3Nib21YcmtncmFJNjV3YUFyMkZISDJW?=
 =?utf-8?B?NHFaME1wSThjRW9jRHJxbURvdWNZKzNDdVFwSnZPVUdkNUloQWZTRTVKaXhl?=
 =?utf-8?B?QThoalhUOHp2SkUycDVreURGVHFEVXpIVGpGVGJSVkpobVJjT1ByUTZYeHVj?=
 =?utf-8?B?Qzd4a2VYZ3JZV2ZMcllUa3R5MWFwakloS2JxL2lUZXRNbFY5a21HRDVsNW1s?=
 =?utf-8?B?ZENLSEFXbXE4MEhJaEd3SUV0NExta3RBYzNXZUJ2bnkrS2FDNk1aUXo0YTVa?=
 =?utf-8?B?dXQyR2dkSVdnSmd4V1dXamNWeW5NcDNlMDF6and4UWI5cm8wTmZJbU9vWmk5?=
 =?utf-8?B?L3BXMytCMnNDK1VBSm5YYmtIUVBETHREVkJBY2RHYU5ncHJuczdmYlYzZ2hi?=
 =?utf-8?B?MkxHME9ockdGRHAwZG56dU5aRzZvNWdRNGJpaU9XSWV5M0VvMGlKak1BeHRh?=
 =?utf-8?B?a3MwYVkyNmIyS3hMNjlkV20vOTB5UGpvdTg5K3lBRmhXV0RHQ0ZhMS8yZDVW?=
 =?utf-8?B?TDVYSTlYTVFOZlF4WVhDV1lLUE5zeW9MdTBObUVmbFAvaVd3K29HdWdWYXhi?=
 =?utf-8?B?MFp5ZTJpNm5JU0RzdU5QK1hVckNVZmJ0TmNnTjROTlBQU1U3RStmTExFVnpY?=
 =?utf-8?B?R1NveG1mUTFPVHN1bUo1ZUZPUHJIM0RvY0pLZlcwMzBhSW5OcHdTckh5OGN0?=
 =?utf-8?B?QVQvYTQ3c1VFZUVTR2I3Mkd4Yk1rdXFwNkZRM1RheVVGWm5BTkVGOHYxYWZt?=
 =?utf-8?B?cjBLVnBrNGtkOW1LNUl4SDVGczZUS0d1WUQ5KzZ1Uk1FWm13Vm1Ea292dGcz?=
 =?utf-8?B?UW9YdUVoS1duSVlGS3g5Tzd0QkU4NjV6b0JlYUViaEZsaXhpTXZ1UlhBMzFr?=
 =?utf-8?B?ZElWdGJxVjR6MnJDVDVlclFzRkxDZktkUTNFSUFBR2R4YktuRkEySWN4SjY5?=
 =?utf-8?B?UWFOWC9CYXhaSEduNmd4YisyNDlaQ0NGbTJWT01pZGF2MDF4a2xCZGkxS2gx?=
 =?utf-8?B?UnJGTm9HVVRJdWk3b0NnRjQ0Yzl3UmRYT3p1dm00VkhUMlpOUFlYbGxmQmd1?=
 =?utf-8?B?bW83Z1lnUWFuY0dmenExTkZ1azdwZExhTlV3eStvYm55S2U4TFNIdnFGNlpF?=
 =?utf-8?B?TFJRZlJ3RjdKZXdtMlpsbVA4cmxyUzRYVGxkalRtbVNueXVTZUFmY3ZMVWx6?=
 =?utf-8?B?R3RoOUZETkZZUEpvQmJRdkRiR0dXSHZ0MHNsSEFBPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGZHMXQ2YzY2RkpVNVVRQ1RPZ3c5eWlwMEs3L1JVZG1CMSthRC92d2lDOHFT?=
 =?utf-8?B?TVdmMEtiN2l0ZXk1c2dIN2FIT1pZWkVLV0JBMmpMT2djWGZESWszYWQ2d0Vz?=
 =?utf-8?B?ZS9jNisrSUZUcys4Yis5c3Jndi9FM2hBdmNtVVZlMFZ1T3VUOU1lZWdJRXdw?=
 =?utf-8?B?OHlpVDc0RmU3d0FIbEZzZis0bWdXbisrbWFtSWRnQ0lVZ3pHL0ZKdW40c2hH?=
 =?utf-8?B?d1hNRk42MlB0M3pMeVRBVlMzaHJTOWM1U3Ewc1VNT2h1TnNqRHMrc1JVeGRF?=
 =?utf-8?B?U2FCdVVvanVvVE1yWi82NDZZS3d1QkpweEQxUkhUWDArbWpnVlA4eVRJZnNq?=
 =?utf-8?B?WXVDOTNXcVdEb0RMcXJnUm5welRDVTZqUTRad2tRTG4yOC94bi9kK09tdGRt?=
 =?utf-8?B?Wm0xT0RJTkM5L20ybElxaDNTYzB4My9WNmxwUlNxWnd6VHNvQllhNUpKbU51?=
 =?utf-8?B?TU83WHh3MElwN244ZHJOR0xRMUJuSXFCR1NvOXRQUmh3b056UTROWTBxTnRR?=
 =?utf-8?B?WGZrL1hXQ0hlcUtBQmp3WlUvRkxTcW9iNVk5ZU14M0xMWEkyNTRnL1hqOU9Q?=
 =?utf-8?B?M3FGaHNCRkNGVjR0ak5HcDkvSGc1cVphT0Vrd0lQS0FjbzdWMVRSSW9OR2ZO?=
 =?utf-8?B?Ynd5d2d0dHdQWVM2S2pSb2MyejBDZUtSenlXVDFQSnFuRnpyWlh4bE8zbDFB?=
 =?utf-8?B?bThBa1N0VUxTYXp3ODRnNUtJVnlzMUlGb1U2cHZQcllhWi9VczNsUjFZbGdM?=
 =?utf-8?B?bTRUcVk4M3ovS3ZaSFFrcFRqOFFoTldQZUFPOHA1UFR6NEk5ZjFBbUpjMXE0?=
 =?utf-8?B?Z0orVEZoZkxxQ3BJcElGUGsrTDBKNEQ1NHlyVnBlWE13ZGZseFV0a0NiZUM3?=
 =?utf-8?B?dng0TTNVbjNaREpxek9SaWxIOS9GL0Q0VE43enAxV1RQWFdXWmZIZU4yY1NB?=
 =?utf-8?B?bUtGQ3IyQnlPck5sTHkyUkIvdTZrcGRkam9xeU1JVnZzYUNlWEg2bHBKYTlH?=
 =?utf-8?B?UG9DMWlTcVNUT2tiT2hOaG1mWWtoNisyZlNjc2JvdzRZNHVGek9PYVQyN2tL?=
 =?utf-8?B?RnR3ejJkTkhtcTNaVTFEaUNkM2ZWVFNZZ0dkR2RaTXVIZ3lOSDh6aXdrZlF1?=
 =?utf-8?B?a1o4dDBUUTFpSmcxTG85dWNKbW5YWmxaNXJtM1NUcTN5azI1UURONVYzNy9t?=
 =?utf-8?B?OXp3aWtmUjRxVzFaWmtwallUSmVYL2lqVnBrVTRsSWlHZTNEUC9UazFya3Zq?=
 =?utf-8?B?aUxrUkZGUHV6ZzlSZ3lucUw1Um9EZFFBTEo5U21GNFNEeCtZNVdKSW5qd2hM?=
 =?utf-8?B?SURPWVU4WVlLLzBCOE1JU2NaOWcwNGRZaGVaYXdVUytGbnd3MWdTbjB0NzRm?=
 =?utf-8?B?MklMRFVkRnhLeDRtMm9qWVluSXBpaXFBc1M0Y3B1ZEQxRGlhUjVOS2RFaVhz?=
 =?utf-8?B?NG1iUXZZNWFzODZMc2FITWJvZWdoVEc0VGNxVzByN1hHdkUvT0VvNXludzcr?=
 =?utf-8?B?eFdqL0trNDlPUGtkanBFZ2JNdmFTSzJwdnhwT1FTZ1JJZ0padFVJdWlEVUNp?=
 =?utf-8?B?akxyZjUxQjgxdlZXeGg4b2N1RFA2cWRyOGZtUW5neWtMS0FSd1dEZVlkclhx?=
 =?utf-8?B?czczekhwSk9uN0VpS2VDNmtUUDlwYmlKZmxkUjd1Rkg1L2Fpc3F5VmMyYnhR?=
 =?utf-8?B?bEZoR1o3Nk5wUkxPRFpGaGR6WmxmdUk3aXVwVnQvcHI1YjQvU3BPbUExaVcy?=
 =?utf-8?B?NW5ubVI4Um1qS3NPWmMxSmdZc1FhNUdHSUdFbWltVjZqL3k1RmhFL01RT0Ex?=
 =?utf-8?B?V0NRcWlUSngvTjlodmp0SGRKVm5ueFhBUHB4T2JZcGFFOWlQRDc2WVdreEFV?=
 =?utf-8?B?TkZpdnNyL0ZvdFRSdTdIcVRsT0ZFdWNmbyswSEdGRGpVREo2RkM5NEdubTky?=
 =?utf-8?Q?zOeqlcV2TYi/bX2C89aiopYWERMCkm1d?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5aba19-ad7d-4c2c-46ff-08df14218c77
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 18:37:23.7342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P251MB0795

On Wed, Sep 16, 2026 at 10:37:28AM -0700, Jérôme Pouiller wrote:
> Usually, you have to specify the name of the tool and the model used.

Sure, will add this extra info for v3. Thanks.

> Was this line generated by git-send-email?

It comes from git format-patch --base=, not send-email. The base is
df2908090cda ("Linux 7.3-rc2").

Kind Regards
Aamir A.

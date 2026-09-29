Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FD84F4022;
	Tue, 29 Sep 2026 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672957; cv=none; b=B3UtaWMkhY2pWLakVDvnFPWgkeXRbReragksEyaLovizxj9B9zApD6uldRDB7E26MeVVUDOp6Ddb54xQY1LS7iDnNAq6qZvbCL6kgEMwvztl3+BeZxfg/yd4KMHsMCXSHl8ST/V4NOazSYNyrdAvxXHwMuoenn77JTXylQ8vims=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672957; c=relaxed/simple;
	bh=VNk8rW11KmdkRMkfbrmZszLCHAhqLRqUKrJIUrw1/VI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q04f0b4bHzVzdkHVzVVtWRViin6Jsin+0tSkkz+d/vUa+tUF8uZqHopJNtiyxlcB4PZPVtbifOsgfisQ0cbMc8STN1q2TT9hJXmIau28Jazp2a+SsdgZecBOqWReUAUXnalVakAF58w5QgSDw4JGp7svr+P1dMC5GigHuqgX2WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QuT1Fykg; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QuT1Fykg"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68T98nKwA1168102, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790672929; bh=VNk8rW11KmdkRMkfbrmZszLCHAhqLRqUKrJIUrw1/VI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=QuT1FykgInPy9uPRahe7tm9rxKAQd4cjVWyWxsdaZW0dlx5YAk6Whfo3F+7D9Vy09
	 pOMn86+8/sDuWHBz2b72ZsL26YAnVGYTMtjYS4OoU5a/TcrwjI5C4LLGOWcybDj0V/
	 iGoMdun9Y5rbSGQDKJwcdT0GoKX9eLRvl7U6E27+VvgPgzCgO1kfx+CXfGjpkwgrrQ
	 W7uT31iH9ahKMyRUG6Aq+1M44Z+FRKlLYqSaAPZbui2c+yTVHmJNlVaPJfMzHiTm9Z
	 U3iaJvjI03kpYU+VKiMBs43YcThWnR7Po8m+Pjxl3lrSGscTZl22hvS3X8NZGeYN1U
	 oaW6enb9o8O3g==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68T98nKwA1168102
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 29 Sep 2026 17:08:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 29 Sep 2026 17:08:49 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 29 Sep 2026 17:08:49 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
   Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v4 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Topic: [PATCH v4 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
Thread-Index: AQHdS6ORhAIu01Pc706RGB6onKA0grbc7Ynw///IiYCACAbNMP//326AgAADGACAAJ/DsA==
Date: Tue, 29 Sep 2026 09:08:49 +0000
Message-ID: <6cd39b84d1b14bfd82887c07f28e154b@realtek.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-7-luka.gejak@linux.dev>
 <afb044e0aef8425880ddb24add9340ab@realtek.com>
 <DLNBECY70VGJ.DRSBNB6M66U8@linux.dev>
 <c7069bdf8e9845e3b26898f545b0d3e5@realtek.com>
 <e38d50f20a710ae0b1424924b16ad260cdb04b99@linux.dev>
 <b6c4c35b28b1262b390d5c05993426e3b6d4ee95@linux.dev>
In-Reply-To: <b6c4c35b28b1262b390d5c05993426e3b6d4ee95@linux.dev>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

PiA+ID4gSSBldmVuIHRoaW5rIHdlIGNhbiBkcm9wIHRoaXMgcGF0Y2gsIG5vIG5lZWQgdG8gdXBk
YXRlIE1BSU5UQUlORVJTLg0KPiA+ID4NCj4gPiBJIGxpdHRsZSBjb25mdXNlZCwgYXMgdGhpcyBj
b25mbGljdHMgcGFzdCBlbWFpbHMgYW5kIHRoaXMgYWJvdmUuDQo+IA0KPiBJICphbSBsaXR0bGUu
Li4NCj4gDQo+IFNvIGhvdyB3b3VsZCB5b3UgbGlrZSB0byBwcm9jZWVkPw0KDQpZb3UgYXJlIHRo
ZSBmaXJzdCBwZW9wbGUgd2hvIGFza3MgbWUgdG8gYWRkIE1BSU5UQUlORVJTLCBhbmQgSSBoYXZl
IG5vdA0KdGhvdWdodCBhYm91dCB0aGF0IGJlZm9yZS4NCg0KQWZ0ZXIgdGhpbmtpbmcgdGhpcyB3
ZWVrZW5kLCBJIHRoaW5rIHRoZSBiYXNpYyByZXF1aXJlbWVudHMgYXJlOg0KDQo+ID4gPiAgQW55
d2F5LCBJIHdhbnQgdG8gc2VlIHBlb3BsZSByZWFsbHkgY29udHJpYnV0ZSBjb21tdW5pdHkgYW5k
IHRoZW4NCj4gPiA+ICBhZGQgdGhlaXIgbmFtZXMsIG5vdCByZXZlcnNlIHdheS4gSSBkb24ndCBs
aWtlIHRvIGNsZWFuIE1BSU5UQUlORVJTDQo+ID4gPiAgc29tZXRpbWUuDQoNClNvLCBpZiB5b3Ug
YXNrIG15IHBlcnNvbmFsIG9waW5pb24gbm93LCBJJ2Qgc2F5IGxldCdzIGRyb3AgdGhpcyBwYXRj
aC4NCg0KQXMgeW91IHN1YnNjcmliZWQgbWFpbGluZyBsaXN0LCBnaXZlIHN1Z2dlc3Rpb25zIGFu
ZCByZXZpZXdlZC1ieSB0byB0aGUNCnBhdGNoZXMgYWZ0ZXIgcmV2aWV3aW5nLiANCg0KUGluZy1L
ZQ0KDQo=

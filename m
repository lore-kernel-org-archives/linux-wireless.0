Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65189272E56
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 02:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789524046; cv=none; b=fQPOrfOpLj4yzeaBRJkYbCTCHCp4u2e0nBYvEjzAqNbr3lEDB6NcBKvwaqQlbnaE+0RZ9d8dL9LmI6QpLDdp940F1JDhmGrb5xjRryBED+3N2sAiMtS8tkxn5nN91KQitdGpF0Y+MrTXGhzmsYCgnqS8vx+jpw8Xp7NUKX5RmeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789524046; c=relaxed/simple;
	bh=zqfFjo7QGWLeeXb8wxCycuZDa1V+A/yQnxv9Jf3/Gtk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rRi6I6arbWpymIb50lYoHSsewAiqpLi030RG86Zd38Fb5dco0skqJaUbDPmAFhXiIm6+8Ith3QxyA0wT9FT0SfsWiZ/r5NkLQoQ4UiyuFr+uoFYr9HbhBYlG8FQ9b6jQf3pDoYBOo3A9b8JnoRxpe8hg9CIPulP1+k76RRPkjtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=m57kWN6J; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="m57kWN6J"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G20PawC2000897, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789524025; bh=zqfFjo7QGWLeeXb8wxCycuZDa1V+A/yQnxv9Jf3/Gtk=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=m57kWN6J4jLGV5BRO2dvUMVGlRcHGs02qBhmiWySmhcrg1atevWDSsjq1Xt0sands
	 RwH0ATY53Sfb7Ns0JqlJPgxi7pCekAz4VYMWrjK3aJwLjamOKKv1X7E1quhgw8ZQrb
	 NhT4pLa1BdrWfiUpBbR2nem0yaGL/xywQ6cJla/vnGX0ArF7WihQfJgb3CmBsXxoPr
	 8a18jzS2m6VDbXnF84b5aFo6qjLMY6PJfAwja3eNNDVl0+Eh1STde8DhfLe/1iNerl
	 B3QPB9//Zf3N5N9qT/AjUOhQE0rijh22Os/Rn4PpP8h/jrJMVu+xSN1NtL8Wyqq147
	 ux9Utp69OMzow==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G20PawC2000897
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 10:00:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 10:00:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 16 Sep 2026 10:00:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ruslan Vagner <rusya92266@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: fix comment typo in hal_btc.c
Thread-Topic: [PATCH] wifi: rtlwifi: fix comment typo in hal_btc.c
Thread-Index: AQHdRRGSmlEO/RggIkufLkqCTcikEbbQc61A
Date: Wed, 16 Sep 2026 02:00:24 +0000
Message-ID: <7d2b6ab9a015464ea93603fbb03b3995@realtek.com>
References: <CAF9RqJ7DS5LU7+8N+=cWZdi1P1Z-X583Ue9n2uHT4xopkeadpg@mail.gmail.com>
In-Reply-To: <CAF9RqJ7DS5LU7+8N+=cWZdi1P1Z-X583Ue9n2uHT4xopkeadpg@mail.gmail.com>
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

UnVzbGFuIFZhZ25lciA8cnVzeWE5MjI2NkBnbWFpbC5jb20+IHdyb3RlOg0KIA0KPiBGaXggdGhl
IHNwZWxsaW5nIGluIGNvbW1lbnRzLiBObyBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFJ1c2xhbiBWYWduZXIgPHJ1c3lhOTIyNjZAZ21haWwuY29tPg0KDQpBY2tlZC1i
eTogUGluZy1LZSBTaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQoNCkFzIHRoaXMgb25seSB0b3Vj
aGVzIHNpbmdsZSBmdW5jdGlvbiwgSSdkIGNoYW5nZSB0aGUgc3ViamVjdCB0bw0KYmVsb3cgZHVy
aW5nIGdldHRpbmcgbWVyZ2VkLg0KDQp3aWZpOiBydGx3aWZpOiBmaXggY29tbWVudCB0eXBvIGlu
IHJ0bDg3MjNlX2RtX2J0X3NldF9idF9kbSgpDQoNCg0K

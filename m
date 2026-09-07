Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173403546CD;
	Mon,  7 Sep 2026 05:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788758616; cv=none; b=fhE0eCqLPLQ4EVcADowa7TGblWGYHtbucvcwHYM1LQSJ9IZGtAu7RSPhRa06/BpR0IGGGukGv1DHS6LjqNCHp8qJMvgCy4J8L/zSY9MO7iTBbfiI1CAiQvDIHE70g4Mh+GeAaIENEuZb6xR7pLSxh9ogPpORvLP/WpkJOVHFvIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788758616; c=relaxed/simple;
	bh=eB9Pl6Q11aJArxZRKKzawMrVEOVQjJuD8+PgwBbou6w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fULONilhbD/tL4G1ulmBOHpJ5fDdTazc0XhK4hLiCofcWEjWBpjFedUAHlQJoJblbH7ah7gZF28R1zeBlgbQ/Vz4c3nNlLFLh2uPCmhtHR6FjOPDKRTX3tD50jYS2fiWPL8ttTCYEQXe3AjW3WAbTOD+xh2br8WHrqiwDbl+05E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Ubu0XgAH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Ubu0XgAH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6875NTAg82520796, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788758609; bh=Ok80kb5roUvAaiIkrHRCm9qOh6Hb4ZGxc+WOMYsVDPc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Ubu0XgAHK9w8wWhWAUz/EEFvxNWjGiQPUCrjq5ZClnZiwip9yTTdOIU/+K2qNYhFv
	 j4zEWV3SHwBQxjL7lCzitM/vSrQAQjALdvg24M7XwdItAq74wuwBDRGjzna4ZTj/wh
	 yt8wZKEUbZXqi3b0T724jJrGiAsTznmXU/m2osNols7kVkSFei8yjwUVOPyRp54nZe
	 mvysQAYfQWf8z45Lg1SPi0A62i861Uu0XiuRIwZqBJfmXaP2UcMBrw9zaeJuKRuuwt
	 NifVDRncBQ7yrVsAOlCwZt/lz2Y9hPuyHh0VaLcRehhZKfvmot+TCN6yfzrrJeaJ/v
	 xaJd/bsvG/TMA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6875NTAg82520796
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 13:23:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 13:23:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 13:23:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hemanth Selam <hemanth.selam@gmail.com>, Jes Sorensen
	<Jes.Sorensen@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] wifi: rtlwifi: fix typos in comments
Thread-Topic: [PATCH v2 2/2] wifi: rtlwifi: fix typos in comments
Thread-Index: AQHdPoQ1ettOZJIOSkiNZzoxbW1mbrbClIag
Date: Mon, 7 Sep 2026 05:23:29 +0000
Message-ID: <c43ea8c573b64074897f7e955f902008@realtek.com>
References: <20260907044851.9884-1-hemanth.selam@gmail.com>
 <20260907044851.9884-3-hemanth.selam@gmail.com>
In-Reply-To: <20260907044851.9884-3-hemanth.selam@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hemanth Selam <hemanth.selam@gmail.com> wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>=20
> Since v1 this is split out of a single "wifi: realtek:" patch, and the
> single-line comments it touches now carry exactly one space after "/*"
> and before "*/", as Ping-Ke Shih asked.  Comment blocks are left alone.

Same here.

>=20
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>





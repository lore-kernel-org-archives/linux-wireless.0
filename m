Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0008422E3F0;
	Mon,  7 Sep 2026 05:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788758505; cv=none; b=UXhB0Sx119tWJjyTwhQY7dS8YKllkMigDl+t5Lz8zVfhLHzrgQSwUApK/aRHr3p5r63EBTk+buLBInt2bFkooGDQOdt/ujaKVrecZDJZTBV8v0FhRwk77ZyERCXNADt2gBJL/Hts330bGJkdC6OLXmw9V/XcqY9DV5lp1LUBeP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788758505; c=relaxed/simple;
	bh=QmuP4BaBxBzul7la2iDfGV6q3V+S58i4Kx6H5u8KCV4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CG7EC/KNRH8UXQYjCi/sMGxPY4oONtkOMS8wJ9e7IW7yukTAm2MFXk9e4pjxMd5Kx1AQoKclDP1MhKTI+0ON+CdmowttVsdN9lk2R9p2Cuq4VrplPclxJDZd4P96KeQrKxkjZ3plaWF5h/6qH4fCZ/9JlO7VVCVC6ftUX+V1k18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LA1/bTIR; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LA1/bTIR"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6875LdccE2519982, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788758499; bh=8Iz9hv/OaTJX9u+81EPLOqbqdcz+5QPDDMWfg5dXyYo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=LA1/bTIRL27eSsN3clN6tmw+HO1JlPJ1nn4TVUO2qft4UFxYVviaf6DxGpOAdSwQC
	 /DkGoaxpbsK36+zG1xErYbBrx3icneHyIxX2N0/QSrqZqiWZYBxhFhlug2n/HaDzMV
	 B55WOElZLBb1e+IoCgpfTJ5wXYXCNNYUU6fO+yNrOm+oMIyC0t/RByY59zdIk9rTNf
	 pIKdAQAvXYSCyHf53WeyLXET4Idnxc+dtmm6Up+Rywp97bnZ5FMr7S0JluQOuXAXSz
	 8nwYCceyWgW2HjkXvdEKV9SpHm5XwGa6mbdTKxM4i63Gn9OFoeTjauQopko1tC9klD
	 gMykCHXApMXMA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6875LdccE2519982
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 7 Sep 2026 13:21:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 7 Sep 2026 13:21:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 7 Sep 2026 13:21:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hemanth Selam <hemanth.selam@gmail.com>, Jes Sorensen
	<Jes.Sorensen@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] wifi: rtl8xxxu: fix typo "Tranceiver" in comment
Thread-Topic: [PATCH v2 1/2] wifi: rtl8xxxu: fix typo "Tranceiver" in comment
Thread-Index: AQHdPoQzWbMOsEZBdUSFHgu0WkIPSLbCk2Xg
Date: Mon, 7 Sep 2026 05:21:39 +0000
Message-ID: <4594e24dac05431eb4ec3889e6de3b5b@realtek.com>
References: <20260907044851.9884-1-hemanth.selam@gmail.com>
 <20260907044851.9884-2-hemanth.selam@gmail.com>
In-Reply-To: <20260907044851.9884-2-hemanth.selam@gmail.com>
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
> Correct "Tranceiver" to "Transceiver", reported by scripts/checkpatch.pl
> using the misspelling list in scripts/spelling.txt.  Only touches a
> comment, no code changes.
>=20
> Split out of a single "wifi: realtek:" patch in v1, as Ping-Ke Shih asked=
.

I will remove this during getting merged. No need to resend because of this=
.

The changelog should be added after delimiter --- following your s-o-b.

>=20
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



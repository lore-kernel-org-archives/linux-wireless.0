Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4E33AEF55;
	Wed, 16 Sep 2026 02:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789527061; cv=none; b=X24+oTuw0GaIRRsf7ynmLav/L42U6seTBbdDmTo0xZATlXWsm5CJSQ1SXyq4zBDs9GIN3jG5W/Hx962x1QxJrmo8VqE1d6Ioz5FPgGM8wGVH9MKhUFcN84FWt9FkxeRqu5K2WMo0lbf2UMOuKA8zqA7kIMZx6gZ3ZxsObknbaTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789527061; c=relaxed/simple;
	bh=W3CDsLy7Vj6abg5DohT79Lk6KyROPdVH4L1fIlkl9PE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=R+Sjv3HUhoIGZXxiSBpIbFJ2BjNe0eNwXJ2crF8fBDQHTw0M+vV31J4VEaGAZMW6HoXi9bqwbzcDNkyAS+eehvvdyLZZoeTXcrS4/8qreZnBNmZ2OIX2VyGZjy/sI7VuysJCgw5q0NnXhtGjvzsYLzR81sJESSTMbo1ouWu0h7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=euuTC4OB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="euuTC4OB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G2osTsB2045312, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789527055; bh=69g96RTrnXD1MzPvWl37Mtq002OLu/IC+zxTQj6pPmk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=euuTC4OBJZyi4Q1iuroX93w0iSOncesN34VJfoMIIM+0xeXZbt2QmE6sSLe7LQclc
	 EGFC9CjtfijL8mnBX/7G8Pjj3oq/Z0erJuKLjMKblljrDE5x1DeoXS2KDsZp/htqDp
	 GAO6sMzvVb4pchRqXpwMuGopnezTbngPmMaJVlGFLiBaUP38ti/+GO4XVMOTuqz2k9
	 USKZkGfUfM7rpzRCc/Kui98SibC3ykF8mu+HxKbtOlfy+ZtSiNNJcXkPpGv+/Q8UTm
	 Y7Ml2pfCLgeTKkF7kItqEAMiE5oR1sSzvH9R14ERThiWJLogZ4oCOnT85Hd0WWOgXx
	 416ubSRc+rghQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G2osTsB2045312
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 10:50:54 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 10:50:54 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 10:50:54 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hemanth Selam <hemanth.selam@gmail.com>, Jes Sorensen
	<Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] wifi: rtl8xxxu: fix typo "Tranceiver" in comment
In-Reply-To: <20260907044851.9884-2-hemanth.selam@gmail.com>
References: <20260907044851.9884-1-hemanth.selam@gmail.com> <20260907044851.9884-2-hemanth.selam@gmail.com>
Message-ID: <2836b54e-a4d8-430a-8544-3290657a2e7d@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 16 Sep 2026 10:50:54 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hemanth Selam <hemanth.selam@gmail.com> wrote:

> Correct "Tranceiver" to "Transceiver", reported by scripts/checkpatch.pl
> using the misspelling list in scripts/spelling.txt.  Only touches a
> comment, no code changes.
> 
> Split out of a single "wifi: realtek:" patch in v1, as Ping-Ke Shih asked.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

8a44d8813de3 wifi: rtl8xxxu: fix typo "Tranceiver" in comment

---
https://github.com/pkshih/rtw.git


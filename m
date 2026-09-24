Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FAC30C165;
	Thu, 24 Sep 2026 01:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790213058; cv=none; b=SjGa5QU9crTruh666YI6y698Ja64hNxp89q4sPo2qmdx83kWYrJckO8+ec+BeEu4g0jrj9R2zxR321m4DVNCzw4nUOxS7T3Hu6Tq4GjxQpAItu6A1u6OT1obDY3ifg69PoYRFg7j8B2taBFZXuyd2wPWZmLuMt5gH+BrodyNvI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790213058; c=relaxed/simple;
	bh=bWLHkHEx500RTqcbIBXrqF+vj0ZFF75ZCg6uHnuV8ZA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bA09X8kPNeu/O3g6xO0T5MqpE6j/w38q0ksMZHw4ML4oethAtaUYQ88pg+7hce4bhBowuszA/WJ7BaQBaS4cRtiDCA2tdX9gyycarKptX9ebDkSG/GV9GLOIxs+RUAT4g385gEKI2G267Kh4r0i5GE3zcR8kTRuDDvNWyahQmbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pdr87xZc; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pdr87xZc"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68O1O5bdC782689, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790213045; bh=ckLzataiL8INfmPyHUYQYpdXsv7nHjVqvggVUw659QA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=pdr87xZcPOo6c1fSMustigmo/9npm0XaYvTGs9MkWG/7s3x3LseXdLFm1WrwsBFNk
	 kUB4FyP+ZAYGIEZCB8xCggAQuqWqBMMIHATDe5FAO4l0DFzgoN3mBZwKAMDX040XhJ
	 MiePAV7AbRI0ddN8q299Cqsr/+VJOU0VNvzyNJn5xj+MThlySMyUi9kBldYfsc1hu1
	 P3Y9cfa/Vh7wcLnBnLf9MtgnduvcF1y8xGUXIxgrv0Qan8epG4v2k1qSPRGTzuGfaU
	 djk2kYxCcIg29vKPb+/jKHVI5aPBQjXdwUQsEIWbbHJUcFfqQKe5jjmWGAW75XHswH
	 PhjBcGVw1C3/A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68O1O5bdC782689
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 24 Sep 2026 09:24:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 24 Sep 2026 09:24:04 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Thu, 24 Sep 2026 09:24:04 +0800
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
Thread-Index: AQHdS6ORhAIu01Pc706RGB6onKA0grbc7Ynw
Date: Thu, 24 Sep 2026 01:24:04 +0000
Message-ID: <afb044e0aef8425880ddb24add9340ab@realtek.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-7-luka.gejak@linux.dev>
In-Reply-To: <20260923213557.186205-7-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> Add Luka Gejak as the maintainer for the RTL8723B/RTL8723BS and
> as designated reviewer for support in rtw88 subsystem.
>=20
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0b42e898f4d8..7851cfcc9368 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23007,6 +23007,13 @@ S:     Maintained
>  F:     Documentation/devicetree/bindings/net/dsa/realtek.yaml
>  F:     drivers/net/dsa/realtek/*
>=20
> +REALTEK RTL8723B WIRELESS DRIVER (rtw88)
> +M:     Luka Gejak <luka.gejak@linux.dev>
> +L:     linux-wireless@vger.kernel.org
> +S:     Maintained
> +F:     drivers/net/wireless/realtek/rtw88/rtw8723b*.c
> +F:     drivers/net/wireless/realtek/rtw88/rtw8723b*.h
> +

I think no need this entry.

Just with below 'R', the ./scripts/get_maintainer.pl with rtw88 patch can
output your name, no?

>  REALTEK SPI-NAND
>  M:     Chris Packham <chris.packham@alliedtelesis.co.nz>
>  S:     Maintained
> @@ -23027,6 +23034,7 @@ F:      drivers/net/wireless/realtek/rtlwifi/
>=20
>  REALTEK WIRELESS DRIVER (rtw88)
>  M:     Ping-Ke Shih <pkshih@realtek.com>
> +R:     Luka Gejak <luka.gejak@linux.dev>
>  L:     linux-wireless@vger.kernel.org
>  S:     Maintained
>  T:     git https://github.com/pkshih/rtw.git
> --
> 2.55.0

By the way, your patch should tag rtw-next (i.e. [PATCH v5 rtw-next]).
Otherwise, NIPA test your patches on wireless-next tree, reporting
errors [1].

I don't know if someone is reading your patches. I'd skip v4.
Please wait a while and send v5.

[1] https://patchwork.kernel.org/user/todo/linux-wireless/?series=3D1172592




Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864A54A6CD1
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 11:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790595118; cv=none; b=DEnk07mwmVRfc+G9Fa/DXhKL7aEL7CMsbB/Ix7TPXYgtkl1oVgzO5kCv115rt4Ew51wcR9dzPOkWMq6HKn8MrKx/mpAAbgNb82Dsf/6IFyEa8dJX3jFK+EjMYSJ1njj/sM3Y1kqHyBhQllJcfr3eJAaX6s7EK9Iio3P7cxpXkWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790595118; c=relaxed/simple;
	bh=6n8VlIQR4RxEU97JfR+BbO3o2h4EONnXlUmRE2Ejn+c=;
	h=Date:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=avPCim0dHKJVhIJVQZC/XwUsjTBLz5NwX/ATgbPOxNED97pU2Vi41WfaWR7oBEte+qfzXrF+M003aAPBnBzn/jkOCOmOd3NbMsSf51izv7GayK9KFBDGYBErbqOhr2A/mKHCdS6uJYdC1yDVi+HI9sXzqmRp8rm83iTr88R8WHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=oCdFRTBQ; arc=none smtp.client-ip=109.224.244.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="oCdFRTBQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790595113; x=1790854313;
	bh=6n8VlIQR4RxEU97JfR+BbO3o2h4EONnXlUmRE2Ejn+c=;
	h=Date:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=oCdFRTBQ4Dhz6vhV05iatfi1Y8IgjBIbZH0S0sTAxm8cbn6z9co9jrPC3niduZZP9
	 dvlrEnA0GwglrdyBd4Zz6C1H+TXSNVGwvWQl+BRxEf2V3OYtGXqmR9pCLIfHRwCTny
	 lAMr97LIchUr1w7vHJfcXVvn75oxGO7LMnopOY/p6DOVeQvBGORjIx92m4Uhu+Whbz
	 gDVwAZGwaI5GiKgBk3S2FVkFqZXe6HwYO5VOll4oga+G+Ltia1oyrdJnTu8rR2N8E3
	 iCY55UvirRN5Le1Ue8ng7KBLEUoAywf8k3L4w4bYFJgUhgoauDqbWBofq4lkLXL0Ig
	 zeat1KhJZBYAg==
Date: Mon, 28 Sep 2026 11:31:50 +0000
From: adisveletanlic <adisveletanlic@proton.me>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Adis Veletanlic <adisveletanlic@proton.me>
Subject: Re: [PATCH wireless] wifi: iwlwifi: mvm: fix self-deadlock in WoWLAN key programming
Message-ID: <7iFmIPid2uOGjWVohSqEyxjzfMI735hdqbZHZ2A5Ba80dkouT1t2tn5vLG4QULDQ5YUYXMqvB0pgrKHJZBSvyN0VC2LoUTNOmc79PPNv_QE=@proton.me>
In-Reply-To: <20260927-main-v1-1-0d59a25f0373@proton.me>
References: <20260927-main-v1-1-0d59a25f0373@proton.me>
Feedback-ID: 138116827:user:proton
X-Pm-Message-ID: ce3f491479aec2f5af5631f0be6be783f9ddb2fc
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Please disregard this copy. I resent it a few minutes later with the
iwlwifi maintainer in To:

https://lore.kernel.org/linux-wireless/20260927-main-v1-1-660ffbc9837c@prot=
on.me/

Sorry for the noise.

Regards,
Adis Veletanlic

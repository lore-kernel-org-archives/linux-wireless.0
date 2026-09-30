Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A1445038;
	Wed, 30 Sep 2026 07:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754590; cv=none; b=NQPwcGW0GfZZDp1fsSoppz3G/HmXJP0lYpVRe3GI6bt0GzY0IoDrZEhxF2zOlaymmDFwWGvzT2fd2M4xSJtdc6XovFagnNesxrYPFXUnYCfoLXl2/JqfAxBUl93rox3MBEzYyhV9znUmbYArgwLkSfjm6WcGYJBbZ6S3mfFc7NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754590; c=relaxed/simple;
	bh=78Gcg8UjJnwQk1chyWNMIJoJxlgEI91vAUqhastEgPI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=K2e5QLcW5z0tNT7mldSnw/ZoZaFoEGmGrrnJopYp8T26Ov1iKEfYgukoOab5gvGvB4V1nxUKAVVV57IM3vbHF42EkhIK3ElDK06nRMbp9mWKbEP6yIjiLxzlL2fou6P1MkMy7+kKoYodsGvHcSsSeX6jmMJ9UrCd8wDPrn1bcEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Nerijus =?utf-8?B?QmVuZMW+acWrbmFz?= <nerijus.bendziunas@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH ath-next v4 0/8] wifi: ath9k: fix register access and
 spectral scan filter handling on ath9k_htc
In-Reply-To: <20260929163015.1779285-1-nerijus.bendziunas@gmail.com>
References: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
 <20260929163015.1779285-1-nerijus.bendziunas@gmail.com>
Date: Wed, 30 Sep 2026 09:49:29 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ecebji0m.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Nerijus Bend=C5=BEi=C5=ABnas <nerijus.bendziunas@gmail.com> writes:

> Hi Toke,
>
> Gentle ping on this series. Please let me know if any changes are
> needed.

Yeah, it's on my list, but I most likely won't get to it until after LPC
(which is next week).

-Toke

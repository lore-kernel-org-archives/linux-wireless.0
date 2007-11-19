Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:38225 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXKSTGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 14:06:50 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1505861rvb
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2007 11:06:50 -0800 (PST)
Message-ID: <43e72e890711191106m40a90d94w230dc0bf0eff2808@mail.gmail.com> (sfid-20071119_190654_683888_89469C2D)
Date: Mon, 19 Nov 2007 14:06:50 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: [PATCH] libertas: add Dan Williams as maintainer
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20071119191652.05023a27@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071117023020.0a164e90@morte>
	 <20071117165551.GA5817@tuxdriver.com> <20071117181153.480d75d8@morte>
	 <1195493292.3248.6.camel@localhost.localdomain>
	 <20071119191652.05023a27@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 19, 2007 1:16 PM, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> Add Dan Williams as maintainer for libertas USB8388 driver.
>
>
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> Cc: Dan Williams <dcbw@redhat.com>
>
> ---
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 18b7c8e..d416260 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2513,6 +2504,12 @@ M:       mtk.manpages@gmail.com
>  W:     ftp://ftp.kernel.org/pub/linux/docs/manpages
>  S:     Maintained
>
> +MARVELL LIBERTAS USB8388 WIRELESS DRIVER

Libertas driver supports PCMCIA devices as well too right? Perhaps
best to just remove the specific "USB8388" here.

  Luis

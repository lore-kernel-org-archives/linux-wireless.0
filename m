Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28796 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbdCTPNY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:13:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alban <albeu@free.fr>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add the DT binding to the ath9k file list
Date: Mon, 20 Mar 2017 14:59:32 +0000
Message-ID: <874lyongdp.fsf@kamboji.qca.qualcomm.com> (sfid-20170320_161505_111007_02E7BEA2)
References: <1489439624-4565-1-git-send-email-albeu@free.fr>
In-Reply-To: <1489439624-4565-1-git-send-email-albeu@free.fr> (Alban's message
        of "Mon, 13 Mar 2017 22:13:24 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alban <albeu@free.fr> writes:

> Changes to the DT binding should also be sent to the ath9k list.
>
> Signed-off-by: Alban <albeu@free.fr>

Use your full name, please.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index c776906..ca5a560 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10370,6 +10370,7 @@ L:	linux-wireless@vger.kernel.org
>  W:	http://wireless.kernel.org/en/users/Drivers/ath9k
>  S:	Supported
>  F:	drivers/net/wireless/ath/ath9k/
> +F:	Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt

You should send this to linux-wireless mailing list, otherwise patchwork
won't see it.

--=20
Kalle Valo=

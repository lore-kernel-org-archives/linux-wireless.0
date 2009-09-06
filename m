Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:35121 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbZIFT0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 15:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <1252259950.9660.179.camel@Joe-Laptop.home>
References: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com>
	<1252259950.9660.179.camel@Joe-Laptop.home>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 6 Sep 2009 12:26:26 -0700
Message-ID: <43e72e890909061226w743e84e6p17fe0d097316678e@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add Atheros Linux wireless drivers home page
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
	Len Widra <Len.Widra@atheros.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Werner Almesberger <werner@openmoko.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, Greg KH <greg@kroah.com>,
	rshlinux@gmail.com, b_yogesh_snowy@yahoo.com,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Harald Welte <laforge@openmoko.org>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 6, 2009 at 10:59 AM, Joe Perches<joe@perches.com> wrote:
> On Thu, 2009-09-03 at 15:54 -0700, Luis R. Rodriguez wrote:
>> I'm pleased to announce the new home page to Atheros Linux wireless drivers:
>> http://wireless.kernel.org/en/users/Drivers/Atheros
>
> Perhaps add this to MAINTAINERS?

Fine by me, except ath5k and ath9k also have their own respective page
so those can also be added.

  Luis

> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8dca9d8..de922cd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -876,6 +876,7 @@ M:  "Luis R. Rodriguez" <lrodriguez@atheros.com>
>  M:     Bob Copeland <me@bobcopeland.com>
>  L:     linux-wireless@vger.kernel.org
>  L:     ath5k-devel@lists.ath5k.org
> +W:     http://wireless.kernel.org/en/users/Drivers/Atheros
>  S:     Maintained
>  F:     drivers/net/wireless/ath/ath5k/
>
> @@ -887,12 +888,14 @@ M:        Vasanthakumar Thiagarajan <vasanth@atheros.com>
>  M:     Senthil Balasubramanian <senthilkumar@atheros.com>
>  L:     linux-wireless@vger.kernel.org
>  L:     ath9k-devel@lists.ath9k.org
> +W:     http://wireless.kernel.org/en/users/Drivers/Atheros
>  S:     Supported
>  F:     drivers/net/wireless/ath/ath9k/
>
>  ATHEROS AR9170 WIRELESS DRIVER
>  M:     Christian Lamparter <chunkeey@web.de>
>  L:     linux-wireless@vger.kernel.org
> +W:     http://wireless.kernel.org/en/users/Drivers/Atheros
>  W:     http://wireless.kernel.org/en/users/Drivers/ar9170
>  S:     Maintained
>  F:     drivers/net/wireless/ath/ar9170/
>
>
>
>

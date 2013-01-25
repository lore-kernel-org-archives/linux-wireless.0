Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f170.google.com ([209.85.160.170]:36057 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3AYMf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 07:35:27 -0500
Received: by mail-gh0-f170.google.com with SMTP id g14so28707ghb.15
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 04:35:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130124210028.GA22800@localhost.localdomain>
References: <20130124205931.GB16252@localhost.localdomain>
	<20130124210028.GA22800@localhost.localdomain>
Date: Fri, 25 Jan 2013 13:28:44 +0100
Message-ID: <CAOZOX0Vj-T1WPHR692LwpSdHontVq5PJG4UJAzg7O=nYLodXOA@mail.gmail.com> (sfid-20130125_133532_708646_3F3D71A9)
Subject: Re: [PATCH 2/4] rt2x00: remove NOTICE
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2013 at 10:00 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> We use this macro only on 3 places - remove it and replace by other
> appropriate macros for printing messages.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00.h    |    2 --
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    4 ++--
>  3 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index a1de95e..1791260 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -80,7 +80,7 @@ static inline bool rt2800_is_305x_soc(struct rt2x00_dev *rt2x00dev)
>             rt2x00_rf(rt2x00dev, RF3022))
>                 return true;
>
> -       NOTICE(rt2x00dev, "Unknown RF chipset on rt305x\n");
> +       INFO(rt2x00dev, "Unknown RF chipset on rt305x\n");
>         return false;
>  }

Isn't this more a warning?

Ivo

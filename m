Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63316 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab2FYXLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 19:11:07 -0400
Received: by lbbgm6 with SMTP id gm6so7185029lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 16:11:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340655140-28950-1-git-send-email-zajec5@gmail.com>
References: <1340655140-28950-1-git-send-email-zajec5@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 26 Jun 2012 09:10:45 +1000
Message-ID: <CAGRGNgVMrS+VbhmJh+jpHtW4NA27XNAJK5=A1LyS83uCWkFRbg@mail.gmail.com> (sfid-20120626_011112_817620_10CD15F2)
Subject: Re: [PATCH] bcma: define some additional cores IDs
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafał,

Minor point:

On Tue, Jun 26, 2012 at 6:12 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> Some of them are BCM4706 specific AFAWK. Most of them was confirmed on
> Netgear WNDR450.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/bcma/scan.c       |    6 ++++++
>  include/linux/bcma/bcma.h |    7 +++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
> index 5ed0718..a342058 100644
> --- a/drivers/bcma/scan.c
> +++ b/drivers/bcma/scan.c
> @@ -70,6 +70,13 @@ struct bcma_host_ops {
>
>  /* Core-ID values. */
>  #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
> +#define BCMA_CORE_4706_CHIPCOMMON      0x500
> +#define BCMA_CORE_4706_SOC_RAM         0x50E
> +#define BCMA_CORE_4706_MAC_GBIT                0x52D
> +#define BCMA_CORE_AMEMC                        0x52E   /* DDR1/2 memory controller core */
> +#define BCMA_CORE_ALTA                 0x534   /* I2S core */
> +#define BCMA_CORE_4706_MAC_GBIT_COMMON 0x5DC
> +#define BCMA_CORE_DDR23_PHY            0x5DD

You don't define a name for the DDR23_PHY core.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

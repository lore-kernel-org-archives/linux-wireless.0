Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:37746 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab1BPWVA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 17:21:00 -0500
Subject: Re: [PATCH 1/2] ssb: trivial: fix SPROM extract warning formatting
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1297861106-18739-1-git-send-email-zajec5@gmail.com> (sfid-20110216_135811_600712_6253D5CA)
References: <1297861106-18739-1-git-send-email-zajec5@gmail.com>
	 (sfid-20110216_135811_600712_6253D5CA)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 23:20:56 +0100
Message-ID: <1297894856.32237.5.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-16 at 13:58 +0100, Rafał Miłecki wrote: 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/ssb/pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 158449e..127897c 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -641,7 +641,7 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
>  		break;
>  	default:
>  		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
> -			   "  revision %d detected. Will extract"
> +			   " revision %d detected. Will extract"
>  			   " v1\n", out->revision);
>  		out->revision = 1;
>  		sprom_extract_r123(out, in);

ack for those two patches.

-- 
Greetings Michael.


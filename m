Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12298 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab0FGTCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 15:02:38 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 07 Jun 2010 12:02:38 -0700
Date: Mon, 7 Jun 2010 12:02:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 11/17] MAINTAINERS: Add STAGING - OTUS 802.11n USB
 WIRELESS DRIVER
Message-ID: <20100607190236.GD29505@tux>
References: <cover.1275935090.git.joe@perches.com>
 <de848b7990a8a691068c8761543a321f4df3f759.1275935091.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <de848b7990a8a691068c8761543a321f4df3f759.1275935091.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 07, 2010 at 11:49:45AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 06eed7b..4494736 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5507,6 +5507,11 @@ M:	Ossama Othman <ossama.othman@intel.com>
>  S:	Odd Fixes
>  F:	drivers/staging/memrar/
>  
> +STAGING - OTUS 802.11n USB WIRELESS DRIVER
> +M:	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
> +S:	Odd Fixes
> +F:	drivers/staging/otus/
> +
>  STARFIRE/DURALAN NETWORK DRIVER
>  M:	Ion Badulescu <ionut@badula.org>
>  S:	Odd Fixes

Nack, this driver is unmaintained and its only purpose is as a
source of documentation for developers working on ar9170 and carl9170.
Once carl9170 gets 11n support and merged upstream then this driver
can be removed.

  Luis

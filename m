Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab1CYQUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 12:20:15 -0400
Date: Fri, 25 Mar 2011 17:19:42 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/12] iwlegacy: MAINTAINERS
Message-ID: <20110325161941.GA2493@redhat.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
 <1301062456-17249-2-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1301062456-17249-2-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 25, 2011 at 07:14:05AM -0700, Wey-Yi Guy wrote:
> Add iwlegacy driver to MAINTAINERS file and mark as 'Orphan'
I'll take these.

> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  MAINTAINERS |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 95482e9..12698b3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3322,6 +3322,16 @@ F:	Documentation/wimax/README.i2400m
>  F:	drivers/net/wimax/i2400m/
>  F:	include/linux/wimax/i2400m.h
>  
> +INTEL PRO/WIRELESS 3945ABG/BG NETWORK CONNECTION SUPPORT
> +L:	linux-wireless@vger.kernel.org
> +S:	Orphan
> +F:	drivers/net/wireless/iwlegacy/
> +
> +INTEL WIRELESS WIFI 4965AGN NETWORK CONNECTION SUPPORT
> +L:	linux-wireless@vger.kernel.org
> +S:	Orphan
> +F:	drivers/net/wireless/iwlegacy/
Since path is the same it should be one entry,
I will post patch soon.

There are some iwlegacy bugs, which seem to be 2.6.34 -> 2.6.35
regression. I'm not seeing other way to fix them as moving
iwlegacy code back to 2.6.34 level. I plan to do this ...

Stanislaw

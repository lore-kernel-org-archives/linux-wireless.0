Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57507 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab2DLDrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 23:47:21 -0400
Message-ID: <1334202406.3788.8.camel@jlt3.sipsolutions.net> (sfid-20120412_054726_193659_CF0127B6)
Subject: Re: [PATCH 05/10] mac80211: Add more ethtools stats: survey, rates,
 etc
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 12 Apr 2012 05:46:46 +0200
In-Reply-To: <1334166738-28243-6-git-send-email-greearb@candelatech.com> (sfid-20120411_195324_260400_4B452B18)
References: <1334166738-28243-1-git-send-email-greearb@candelatech.com>
	 <1334166738-28243-6-git-send-email-greearb@candelatech.com>
	 (sfid-20120411_195324_260400_4B452B18)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-11 at 10:52 -0700, greearb@candelatech.com wrote:

> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -19,6 +19,7 @@
>  #include "cfg.h"
>  #include "rate.h"
>  #include "mesh.h"
> +#include "../wireless/core.h"

NACK. Don't do that.

johannes


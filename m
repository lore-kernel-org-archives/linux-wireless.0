Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:51031 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753216AbXLUW3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 17:29:31 -0500
Date: Fri, 21 Dec 2007 23:26:30 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	sam <sam@ravnborg.org>, Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH v2] mac80211: better rate control algorithm selection
Message-ID: <20071221232630.6fca7a5c@morte> (sfid-20071221_222936_838770_33796AA3)
In-Reply-To: <1198273392.16241.87.camel@johannes.berg>
References: <1198253375.16241.76.camel@johannes.berg>
	<1198273392.16241.87.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 21 Dec 2007 22:43:11 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> This patch changes mac80211's Kconfig/Makefile to:
>  * select between the PID and the SIMPLE rate control
>    algorithm as default
>  * always allow tri-state for the rate control algorithms,
>    building those that are selected 'y' into the mac80211
>    module (if that is a module, otherwise all into the kernel)
>  * force the default rate control algorithm to be built into
>    mac80211
> 
> It also makes both rate control algorithms proper modules again
> with MODULE_LICENSE etc.
> 
> Only if EMBEDDED is the user allowed to select "NONE" as default
> which will cause no algorithm to be selected, this will work
> only when the driver brings one itself (e.g. iwlwifi drivers).
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Stefano Brivio <stefano.brivio@polimi.it>


-- 
Ciao
Stefano

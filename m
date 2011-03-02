Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1397 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab1CBTYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 14:24:09 -0500
To: "Brett Rudley" <brudley@broadcom.com>,
	"Javier Martinez Canillas" <martinez.javier@gmail.com>
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 1/2] staging: brcm80211: Add buf_size parameter to
 ampdu_action handler function
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
Date: Wed, 2 Mar 2011 20:23:43 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vrqdhre53ri7v4@arend-laptop>
In-Reply-To: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 27 Feb 2011 21:54:14 +0100, Javier Martinez Canillas  
<martinez.javier@gmail.com> wrote:

Hi Javier,

> struct ieee80211_ops.ampdu_action function pointer definition now  
> includes a
> u8 buf_size parameter.
>
> Update wl_ops_ampdu_action handler function according to this new  
> signature.
>
This currently gives a warning on staging-next branch:

drivers/staging/brcm80211/brcmsmac/wl_mac80211.c:699: warning:  
initialization from incompatible pointer type

>
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>

Probably you have used a newer net/mac80211.h as reference which has not  
yet landed on the staging-next branch.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"


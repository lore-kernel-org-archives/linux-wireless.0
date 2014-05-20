Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36398 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaETIPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:15:52 -0400
Message-ID: <1400573741.4474.1.camel@jlt4.sipsolutions.net> (sfid-20140520_101556_805062_0B644659)
Subject: Re: [PATCH 1/2] cfg80211: constify MAC addresses in cfg80211 ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 20 May 2014 10:15:41 +0200
In-Reply-To: <537B0EBD.5080900@broadcom.com>
References: <1400514847-17594-1-git-send-email-johannes@sipsolutions.net>
	 <537B0EBD.5080900@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-20 at 10:13 +0200, Arend van Spriel wrote:
> On 05/19/14 17:54, Johannes Berg wrote:
> > From: Johannes Berg<johannes.berg@intel.com>
> >
> > This propagates through all the drivers and mac80211.
> >
> Acked-by: Arend van Spriel <arend@broadcom.com>
> > Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> > ---
> 
> Should this also be done for the macaddr field in struct vif_params?

That'd be difficult to do since it's a real value, not just a pointer,
so it must be filled by something :)

johannes


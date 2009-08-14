Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:53190 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZHNKlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 06:41:49 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Deauthentications with p54usb
Date: Fri, 14 Aug 2009 12:41:55 +0200
Cc: wireless <linux-wireless@vger.kernel.org>
References: <1763718213@web.de> <4A84995C.8060109@lwfinger.net>
In-Reply-To: <4A84995C.8060109@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200908141241.56013.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 00:53:16 Larry Finger wrote:
> Chunkeey@web.de wrote:
> > "Larry Finger" <Larry.Finger@lwfinger.net> wrote:
> >> I'll try to collect a dump.
> >>
> > Any news regarding that dump?
> > Or are you too busy reviewing b43's LP code? :)
> > 
> > It looks like more drivers are affected. 
> >  - Luis reported some deauth (reasons=7) for ath9k with a cisco ap.
> >  - Kalle has the same issues with wl1271 with a ?Zyxel? AP.
> 
> Not only reviewing the code, but updating the specs and doing the RE
> work. No, I have no further info. Mine have been on a Linksys AP.
yeah, b43 definitely needs the attention.

The powersave default mode should be back to "off" for p54, due to:
"[PATCH] cfg80211: allow driver to override PS default".
so, no need to revert the psm patch again.

Regards,
	Chr

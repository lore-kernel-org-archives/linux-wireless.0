Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58326 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbYHOUNA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 16:13:00 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted from commit 741b4fbc44
Date: Fri, 15 Aug 2008 22:15:05 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808152034.46346.chunkeey@web.de> <1218828375.3197.0.camel@localhost>
In-Reply-To: <1218828375.3197.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808152215.05761.chunkeey@web.de> (sfid-20080815_221304_514323_F90670BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 August 2008 21:26:15 Johannes Berg wrote:
> On Fri, 2008-08-15 at 20:34 +0200, Chr wrote:
> > Hmm, or there's something else can't count?!??
> >
> > Anyway, the firmware will always assign (as in overwrite) the
> > sequence number for every transmitted frame... unfortunatly
> > there isn't a uniform way to disable this behaviour.
>
> If it always does that, then it cannot be implementing QoS properly.

hmm? has this something to do with the per STA TID in 
7.1.3.4.1 (802.11-2007) ?

Well the firmware (aka: LowerMAC) has some sort station
database so there could be some room for that... maybe.

(But yes, when I was playing with the AP/IBSS, 
all beacon frames had a running sequence counter...

maybe you can see this with a cx3110x in IBSS mode too?!)

Regards,
	Chr


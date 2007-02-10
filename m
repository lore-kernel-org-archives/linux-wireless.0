Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:33980 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbXBJRN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 12:13:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Sat, 10 Feb 2007 18:11:36 +0100
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702091753.12419.mb@bu3sch.de>
In-Reply-To: <200702091753.12419.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702101811.37355.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 9 February 2007 17:53, Michael Buesch wrote:
> On Friday 09 February 2007 17:18, Larry Finger wrote:
> > After a suspend/resume cycle, bcm43xx-softmac has lost its association with
> > the AP and requires manual intervention. This situation is fixed by making
> > one of softmac's internal routines public and calling it.
> > 
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Ack, this is good as workaround.

I'm running with this patch applied right now, but the association is lost
after the resume anyway.  I have to reload bcm43xx to make it associate with
the AP again (no big deal).

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

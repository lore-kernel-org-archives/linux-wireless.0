Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbXKUVeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 16:34:36 -0500
Message-ID: <4744A443.6070808@redhat.com> (sfid-20071121_213439_329404_00D247D5)
Date: Wed, 21 Nov 2007 16:33:55 -0500
From: Chuck Ebbert <cebbert@redhat.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Changes to enable BCM4311 rev 02 with wireless core
 revision 13
References: <474487a9.9c54/m97tX72L4+l%Larry.Finger@lwfinger.net>
In-Reply-To: <474487a9.9c54/m97tX72L4+l%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2007 02:31 PM, Larry Finger wrote:
> The BCM94311MCG rev 02 chip has an 802.11 core with revision 13 and
> has not been supported until now. The changes include the following:
> 

I put this in a private build of the Fedora 8 kernel in place of the
the one that was added a few days ago.

This one works, but I get "PHY transmission error", probably because
the rfkill switch has disabled it. I see two LED devices and an input
device were registered but pushing the rfkill switch has no effect.
Googling doesn't yield any directions for enabling the switch...


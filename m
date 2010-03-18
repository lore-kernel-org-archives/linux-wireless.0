Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0CRUxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 16:53:00 -0400
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4BA266FB.1080507@lwfinger.net>
References: <4BA266FB.1080507@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 13:53:00 -0700
Message-ID: <1268945580.4005.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 12:46 -0500, Larry Finger wrote:
> Michael,
> 
> I'm switching this discussion from the kernel Bugzilla to the lists.
> 
> As you know, but I'm restating for anyone that has not read our previous
> discussions, the b43 driver needs to be changed to handle some of the newer
> devices do not have an on-board SPROM. It would be trivial to incorporate the
> data except for the need to have a unique, reproducible MAC.

Where does the data usually come from in these devices?

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:35578 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbXGLSjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 14:39:12 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1I93Zo-0005Ho-NT
	for linux-wireless@vger.kernel.org; Thu, 12 Jul 2007 14:39:44 -0400
Subject: Re: at76_usb - fourth submission attempt
From: Pavel Roskin <proski@gnu.org>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org, Guido Guenther <agx@sigxcpu.org>,
	at76c503a-develop@lists.berlios.de
In-Reply-To: <20070712201702.72209493@griffin.suse.cz>
References: <1184228166.2377.31.camel@dv>
	 <20070712201702.72209493@griffin.suse.cz>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 14:39:07 -0400
Message-Id: <1184265547.29486.2.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-07-12 at 20:17 +0200, Jiri Benc wrote:

> Could you send a direct pointer to the patch? And make a patch that
> creates those at76_usb* files in the correct dir by itself? That will
> ease the review a lot.

http://80211libre.org/at76/at76_usb_try4.patch

Individual files are in http://80211libre.org/at76/

> > The biggest change that has not been done is conversion to mac80211.  I
> > believe it's possible, but I don't expect it to happen overnight.  Until
> > then, at76_usb uses its own implementation of 802.11 protocol.
> 
> Unfortunately, that prevents being accepted to vanilla.
> 
> I'd suggest to convert the driver to mac80211 and submit it then;
> otherwise people will tend to look at the code saying "NAK, it contains
> its own home grown 802.11 stack" only and not to review the driver in
> depth.

Well, that make sense.  Helpers are welcome :)

-- 
Regards,
Pavel Roskin


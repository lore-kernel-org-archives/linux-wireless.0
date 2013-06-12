Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from linicks.net ([87.127.191.50]:48651 "EHLO mail.linicks.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3FLMBm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 08:01:42 -0400
Date: Wed, 12 Jun 2013 13:01:41 +0100
From: Nick Warne <nick@linicks.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [QUERY] Intel Centrino Wireless-N 100 modules vs built-in
Message-ID: <20130612120141.GB10459@sauron> (sfid-20130612_140145_406554_B6406F7F)
References: <20130612112326.GA10313@sauron>
 <1371037816.8601.13.camel@jlt4.sipsolutions.net>
 <1371038139.8601.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371038139.8601.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 12, 2013 at 01:55:39PM +0200, Johannes Berg wrote:
> 
> > Newer versions of udev don't
> > respond negatively if they don't have the firmware while running from
> > initrd/initramfs, and will leave the driver's request pending to be
> > answered once the real filesystem is mounted.
> 
> And by "newer", I really mean "anything not ancient", the version with
> the logic was 187, released almost a year ago :-)

I will have to wait for debian/ubuntu/mint to catch up then :)

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/

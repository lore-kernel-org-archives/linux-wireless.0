Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:11399 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZIHTpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 15:45:33 -0400
Received: by qw-out-2122.google.com with SMTP id 9so133550qwb.37
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 12:45:36 -0700 (PDT)
Date: Tue, 8 Sep 2009 14:06:09 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: rt2x00 Users List <users@host1.serialmonkey.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] rt2x00: Hardcode TX ack timeout and consume time
Message-ID: <20090908120608.GA4296@linux-m68k.org>
References: <200909061514.23611.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200909061514.23611.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 06, 2009 at 03:14:23PM +0200, Ivo van Doorn wrote:
> rt2x00: Hardcode TX ack timeout and consume time

Hi,

it does significantly improve rt73usb performance and stability of ping times.

I can still get almost the double performance and much better ping times when 
setting the rate manually.

> John, this patch has not yet been confirmed by any of the above bugzilla reports,
> but I do think this should be merged as soon as possible to 2.6.31 since this issue
> has been marked as regression for quite some time now. :)

imho it should be merged even if it does not fully fix every imaginable problem.

Actually I would wish critical fixes would be merged much more aggressively,
eg rt73usb was critically broken before Pavel Roskin' recent off-by-1 register
access fix - causing all kinds of weird problems probably including filesystem
damage.

Seems some other fixes are also critical - it would be nice to have all important
fixes in eg in 2.6.30.6 (if it ever comes) as it is not quite trivial to cherrypick
them from the list when the code diverges too much from mainline.

Richard

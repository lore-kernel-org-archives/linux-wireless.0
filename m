Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:44003 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYFPDkm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 23:40:42 -0400
Subject: Re: Problem with master mode on BCM4318
From: Pavel Roskin <proski@gnu.org>
To: Mark Roberts <mroberts1839@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com>
References: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 23:40:39 -0400
Message-Id: <1213587639.2469.10.camel@dv> (sfid-20080616_093323_086453_C5664731)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-16 at 12:24 +0900, Mark Roberts wrote:

> I noticed the warning in the dmesg output about having old firmware
> and I've followed the instructions on the web site to install it, but
> it seems to make no difference. I still see the warning.
> 
> I assume that I'm doing something wrong, but I cannot tell.

You didn't write anything about the procedure you used to install the
firmware, so it impossible for others to see what was wrong with it.
Perhaps you should find where the original firmware is installed, move
it away and make sure the new firmware appears there if you install it.

> To be
> honest, I don't find the documentation on linuxwireless.org to be very
> clear or well-presented. It seems to be written primarily for
> developers, not end-users as the site advertises.

You didn't specify which exactly instructions you followed.  There is
more than one page there.  Master mode support is definitely not
intended for the end users at this point.

> At this point, I'm stuck. Any suggestions?

Be specific.

-- 
Regards,
Pavel Roskin

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbYIJFZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 01:25:26 -0400
Date: Tue, 9 Sep 2008 22:19:22 -0700
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH V2] b43legacy: Fix failure in rate-adjustment mechanism
Message-ID: <20080910051922.GB3246@kroah.com> (sfid-20080910_072531_304540_94D72E2F)
References: <48c2fb5a.JqLELi8PJxjxmDaY%Larry.Finger@lwfinger.net> <200809070040.04300.mb@bu3sch.de> <20080908053155.GI4099@kroah.com> <48C55153.3070309@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48C55153.3070309@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 11:22:43AM -0500, Larry Finger wrote:
> Greg KH wrote:
>> Bug fixes, not new features, it's pretty simple :)
>
> Just bug fixes, or does it have to be a regression?

See the detailed rules in Documentation/stable_kernel_rules.txt

thanks,

greg k-h

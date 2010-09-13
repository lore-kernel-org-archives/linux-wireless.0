Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59199 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab0IMTsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:04 -0400
Date: Mon, 13 Sep 2010 12:48:37 -0700
From: Greg KH <greg@kroah.com>
To: Jason <linuxdriverproject@lakedaemon.net>
Cc: Mike Rapoport <mike@compulab.co.il>, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
Message-ID: <20100913194837.GA8848@kroah.com>
References: <20100908150322.17dac9c3@nehalam> <20100908225132.GA12490@kroah.com> <4C88F8CE.5090708@broadcom.com> <4C8DD9F4.5090305@compulab.co.il> <20100913154227.GB24563@kroah.com> <4C8E744A.2020906@lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C8E744A.2020906@lakedaemon.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 13, 2010 at 02:58:18PM -0400, Jason wrote:
> I'm currently working through the checkpatch issues for
> staging/brcm80211/*, so far, I've done:
>
> ERROR: "foo * bar" should be "foo *bar"
> ERROR: open brace '{' following function dec...
> ERROR: return is not a function, paren...
> ERROR: do not use assignment in if condition
> ERROR: trailing statements should be on next line
> ERROR: that open brace { ... prev line
> ERROR: while should follow close brace '}'
> ERROR: do not initialise globals to 0 or NULL
> ERROR: do not initialise statics to 0 or NULL
> ERROR: Macros w/ complex values ... parenthesis
> ERROR: Macros w/ mult. statements ... do - while loop
>
> The only remaining errors are whitespace, then I'll move on to warnings.  
> Since this is my first large (arguably trivial ;-) ) patchset, do you
> want them one by one as I finish them, or the whole thing in one shot?

One thing per commit please.

> btw, each "ERROR: ..." line above is one commit.

Great, so you should be all set.  Send them on, I'll queue them up :)

thanks,

greg k-h

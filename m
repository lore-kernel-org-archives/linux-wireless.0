Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47915 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbXIVPSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 11:18:31 -0400
Date: Sat, 22 Sep 2007 08:13:35 -0700
From: Greg KH <gregkh@suse.de>
To: Alninuo_Li@sdc.sercomm.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	David Brownell <david-b@pacbell.net>,
	linux-usb-devel@lists.sourceforge.net, jeff@garzik.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-usb-users@lists.sourceforge.net, mb@bu3sch.de,
	zambrano@broadcom.com, davem@davemloft.net
Subject: Re: ?^?H?G Re: ?^?H?G Re: [linux-usb-devel] Please pull  'ssb-drivers' branch of wireless-2.6  -- aln.
Message-ID: <20070922151335.GA5428@suse.de>
References: <OF2983FA30.A28D686E-ON4825735E.004F310B-4825735E.004F7C82@sdc.sercomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <OF2983FA30.A28D686E-ON4825735E.004F310B-4825735E.004F7C82@sdc.sercomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 22, 2007 at 10:28:23PM +0800, Alninuo_Li@sdc.sercomm.com wrote:
> Hi Greg, 
>         It should be the right name now, apologize for the typo., anyway, 
> glad to get the response from u.
>         I think the usbserial crash, or the printk crash is a small bug, 
> likely interrupt handling, but since I have no much idea for the driver, 
> so I need some helpful advice to debug on, 
>         And also for now, we have no much time to move from 2.4 to 2.6, 
> since the time to market is no room for us, which means the full 
> integration for other feature points.

Again, no one supports 2.4 anymore, so you are on your own.  Remember,
the 2.4.20 kernel was released almost 5 _years_ ago.  There are numerous
security holes in that kernel, as well as bugs that have been fixed in
newer releases.  If you insist on using that release, you are on your
own.

good luck,

greg k-h

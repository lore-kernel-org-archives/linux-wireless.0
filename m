Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:38248 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbYKNNbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 08:31:39 -0500
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1L0ylk-0004zs-GE
	for linux-wireless@vger.kernel.org; Fri, 14 Nov 2008 14:31:28 +0100
Date: Fri, 14 Nov 2008 08:26:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Johannes Berg
	<public-johannes-cdvu00un1VgdHxzADdlk8Q@hugh.gmane.org>,
	"otus-devel-qhrM8SXbD5K0lq1k9DReS6gKWPgB4RSr2LY78lusg7I@public.gmane.org"
	<public-otus-devel-qhrM8SXbD5K0lq1k9DReS6gKWPgB4RSr2LY78lusg7I@hugh.gmane.org>,
	linux-wireless
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	Greg KH <greg@kroah.com>
Subject: Re: [FYI] ar9170 driver
Message-ID: <20081114132645.GA3443@tuxdriver.com> (sfid-20081114_143143_375015_38B15BD9)
References: <1226531034.14186.39.camel@johannes.berg> <491D380D.7050707@teltonika.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <491D380D.7050707@teltonika.lt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, Nov 14, 2008 at 10:34:21AM +0200, Paulius Zaleckas wrote:
> 
> 
> Johannes Berg wrote:
> > This patch adds the ar9170 driver for Atheros 802.11n
> > USB hardware ("otus").
> > 
> > NOTES/TODO
> >  * locks up RX part of the device after a while and the device
> >    starts messing with the USB bus
> >    (message will be "complete rx %p (0b, -75)")
> >  * need to implement RF, TX power calibration based on EEPROM
> >    values (maybe causing the RX hangs? doubt it)
> >  * already needs some code cleanups
> >  * use rate hw_value instead of huge switch statement
> >  * implement configure_filter
> >  * implement bss_config call
> >  * implement beaconing
> >  * implement hardware crypto
> >  * implement AP mode
> >  * implement mesh mode
> 
> If this driver is not going in through wireless or any other tree, because it
> still needs some work, maybe it is worth to get it to staging tree maintained
> by Greg?

I really don't think that is necessary.  I don't forsee any problem w/
Johannes getting his driver merged.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:48133 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400Ab2F3Pq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 11:46:27 -0400
Received: by lbol5 with SMTP id l5so6350131lbo.20
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jun 2012 08:46:24 -0700 (PDT)
Message-ID: <1341071182.1631.754.camel@cumari.coelho.fi> (sfid-20120630_174642_787324_E4B2D655)
Subject: Re: linux-firmware: pull-request wl12xx 2012-06-27
From: Luciano Coelho <coelho@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, arik@wizery.com
Date: Sat, 30 Jun 2012 18:46:22 +0300
In-Reply-To: <1341068113.4852.25.camel@deadeye.wl.decadent.org.uk>
References: <1340817712.1631.633.camel@cumari.coelho.fi>
	 <1341068113.4852.25.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-30 at 15:55 +0100, Ben Hutchings wrote:
> On Wed, 2012-06-27 at 20:21 +0300, Luciano Coelho wrote:
> > Hi Ben,
> > 
> > Here are some new versions of TI's WLAN firmwares.  Also a new one for a
> > new chip we started supporting recently.
> > 
> > Please let me know if there are any problems.
> 
> This adds firmware that's requested by a new driver:
> 
> [...]
> >       wl18xx: add firmware for WiLink8 WLAN chips
> [...]
> 
> The new driver should get its own section in WHENCE.

Ah, sorry, I missed that.  We actually now have a "wlcore" which is used
by both wl12xx and wl18xx, so I have put all the firmwares together.
But it makes more sense have separate sections for each driver.  I'll
add a separate section for wl18xx and send v2 of my pull-request.

Thanks!

--
Luca.


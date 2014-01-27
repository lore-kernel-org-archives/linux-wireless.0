Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaA0B2D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 20:28:03 -0500
Date: Sun, 26 Jan 2014 17:29:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [FIRMWARE PATCH] rtlwifi: Add firmware for rtl8821ae
Message-ID: <20140127012905.GA27746@kroah.com> (sfid-20140127_022827_883301_D8FD80EB)
References: <20140123163807.GA16360@kroah.com>
 <1390783732.2735.85.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390783732.2735.85.camel@deadeye.wl.decadent.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 27, 2014 at 12:48:52AM +0000, Ben Hutchings wrote:
> On Thu, 2014-01-23 at 08:38 -0800, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This firmware is for a driver for the Realtek 8821AE PCI WIFI device.
> > It came from a tarball from Realtek named
> > wifi_driver_8821ae_0018.1129.2013.tar.gz and is allowed to be
> > distributed under the LICENCE.rtlwifi_firmware.txt license.
> > 
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  WHENCE                  |   9 +++++++++
> >  rtlwifi/rtl8821aefw.bin | Bin 0 -> 29198 bytes
> >  2 files changed, 9 insertions(+)
> >  create mode 100644 rtlwifi/rtl8821aefw.bin
> 
> Applid, but:
> 
> > diff --git a/WHENCE b/WHENCE
> > index 00767b179a68..16ab53e2ba75 100644
> > --- a/WHENCE
> > +++ b/WHENCE
> > @@ -1962,6 +1962,15 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
> >  
> >  --------------------------------------------------------------------------
> >  
> > +Driver: rtl8821ae - Realtek 802.11n WLAN driver for RTL8821AE
> > +
> > +Info: Taken from Realtek version wifi_driver_8821ae_0018.1129.2013.tar.gz
> > +File: rtlwifi/rtl8821ae.bin
> [...]
> 
> This didn't match the actual filename.  I fixed it up this time, but
> please take care to make this match.  (Really I should script a check
> for this.)

Ah, sorry about that, I did it by hand, thanks for fixing it.

greg k-h

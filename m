Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:60113 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1DMEHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 00:07:37 -0400
Date: Wed, 13 Apr 2011 09:29:48 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mwl8k: Fix checkpatch.pl and sparse warnings and errors
Message-ID: <20110413035947.GA4938@hertz.marvell.com>
References: <20110408185529.GA26751@hertz.marvell.com>
 <20110412202831.GC24309@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110412202831.GC24309@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,
   Please see in-line.

On Tue, Apr 12, 2011 at 01:28:32PM -0700, John W. Linville wrote:
> On Sat, Apr 09, 2011 at 12:25:37AM +0530, Yogesh Ashok Powar wrote:
> > Fix checkpatch errors and warnings comprising of indent errors, spaces and
> > __packed warnings. Also fix 'make C = 2' warnings.
> > 
> > Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> > ---
> >  drivers/net/wireless/mwl8k.c |   27 +++++++++++++--------------
> >  1 files changed, 13 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> > index 8913180..fb472f4 100644
> > --- a/drivers/net/wireless/mwl8k.c
> > +++ b/drivers/net/wireless/mwl8k.c
> > @@ -701,7 +701,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
> >  			       "helper image\n", pci_name(priv->pdev));
> >  			return rc;
> >  		}
> > -		msleep(5);
> > +		msleep(20);
> >  
> >  		rc = mwl8k_feed_fw_image(priv, fw->data, fw->size);
> >  	} else {
> 
> Is this an indent error, a space, or a __packed warning??

This was checkpatch warning. The exact warning is as below

>WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.txt
>+		msleep(5);

Thanks
Yogesh Powar

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:15245 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYA1N4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 08:56:09 -0500
Received: by an-out-0708.google.com with SMTP id d31so364258and.103
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2008 05:56:08 -0800 (PST)
Date: Mon, 28 Jan 2008 08:56:03 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rfkill: add the WiMAX radio type
Message-ID: <20080128085422.ZZRA012@mailhub.coreip.homeip.net> (sfid-20080128_135628_186665_65611AD7)
References: <200801231324.39483.inaky@linux.intel.com> <200801232230.39590.IvDoorn@gmail.com> <200801231338.53501.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801231338.53501.inaky@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Inaky,

On Wed, Jan 23, 2008 at 01:38:53PM -0800, Inaky Perez-Gonzalez wrote:
> 
> Dimitry, are you ok with the include/linux/input.h part \
> of the patch below (chopped); full version at 
> 
> http://marc.info/?l=linux-wireless&m=120112423923171&w=2
> 
> > 
> > > ---
> > > 
> > > diff -r a52d5e9e9c91 include/linux/input.h
> > > --- a/include/linux/input.h	Mon Jan 14 16:13:06 2008 -0800
> > > +++ b/include/linux/input.h	Mon Jan 14 16:23:40 2008 -0800
> > > @@ -362,6 +362,8 @@ struct input_absinfo {
> > >  #define KEY_BRIGHTNESS_CYCLE	243	/* brightness up, after max is min */
> > >  #define KEY_BRIGHTNESS_ZERO	244	/* brightness off, use ambient */
> > >  #define KEY_DISPLAY_OFF		245	/* display device to off state */
> > > +
> > > +#define KEY_WIMAX		246
> > >  
> > >  #define BTN_MISC		0x100
> > >  #define BTN_0			0x100
> > > diff -r a52d5e9e9c91 include/linux/rfkill.h

Yes, that should work, thank you. This will go through the network
tree, right?

-- 
Dmitry

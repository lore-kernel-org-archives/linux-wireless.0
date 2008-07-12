Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:5477 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbYGLPDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 11:03:21 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1296961nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2008 08:03:17 -0700 (PDT)
To: Pavel Roskin <proski@gnu.org>
Subject: Re: rt2x00 is still experimental?
Date: Sat, 12 Jul 2008 17:13:54 +0200
Cc: linux-wireless@vger.kernel.org
References: <1215811139.30975.10.camel@dv> <200807121025.43801.IvDoorn@gmail.com> <20080712104659.jsizw0ndw44cw4kc-cebfxv@webmail.spamcop.net>
In-Reply-To: <20080712104659.jsizw0ndw44cw4kc-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807121713.54123.IvDoorn@gmail.com> (sfid-20080712_170327_591241_4954A0BC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 12 July 2008, Pavel Roskin wrote:
> Quoting Ivo van Doorn <ivdoorn@gmail.com>:
> 
> > Hi,
> >
> >> Can we please have rt2x00 drivers considered stable in Linux 2.6.27?
> >
> > No.
> >
> >> My experience running rt73 day by day with WPA on a very crowded network
> >> shows that it's a pretty reliable driver already.
> >
> > Perhaps managed mode, but not adhoc mode, beaconing is still broken.
> > In addition the leds are broken as well, and hardware encryption   
> > isn't in either.
> 
> I see.  It must be a perception thing.  Things I hack on seem  
> unstable, but things that just work seem stable :)

Well it is at least good to know managed mode is working well for you. :)

> Thank you for the status.  Good luck with fixing the remaining problems!

Thanks,

Ivo

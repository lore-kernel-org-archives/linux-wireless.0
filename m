Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:38097 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXHBOKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 10:10:16 -0400
Received: by ug-out-1314.google.com with SMTP id j3so345244ugf
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 07:10:15 -0700 (PDT)
To: dragoran <drago01@gmail.com>
Subject: Re: rt2500usb stopped working (vendor request error)
Date: Thu, 2 Aug 2007 16:14:29 +0200
Cc: linux-wireless@vger.kernel.org
References: <46B1B0AE.7050205@gmail.com> <200708021315.19626.IvDoorn@gmail.com> <46B1C20B.7020601@gmail.com>
In-Reply-To: <46B1C20B.7020601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708021614.29385.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
 
> >> I was using rt2x00 with hostapd to create a AP and it worked fine in FC6 
> >> with rt2x00-cvs-2007020803.
> >> But after upgrading to F7 it stopped working. I am using kernel 
> >> kernel-2.6.22.1-41.fc7 which have a recent wireless-dev copy of the 
> >> driver but I just get this errors in dmesg:
> >>     
> >
> > <... snip...>
> >
> >   
> >> Any idea whats going on?
> >> Can I provide more info to help finding a solution?
> >> I already reported it here before:
> >> http://rt2x00.serialmonkey.com/phpBB2/viewtopic.php?t=4042
> >> but got no usefull replies so I decided to try here.
> >>     
> >
> > Could you retry with a more recent version?
> >
> >   
> what do you mean by more recent?
> its a some days old wireless-dev snapshot (31-07-2007).
> has something changed in the past 2 days that could fix it?

Well I don't know which rt2x00 version was shipped with 2.6.22.1-41-fc7,
not do I know when it was released. Your last posted on the forum dated
from July 13th.
And regarding the patches, last tuesday I have released rt2x00 2.0.5 which
was then merged with wireless-dev, but the release itself contained quite
a lot of patches...

Ivo

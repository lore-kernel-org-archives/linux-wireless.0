Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35541 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2EaJW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 05:22:58 -0400
Received: by eeit10 with SMTP id t10so230892eei.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 02:22:57 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Master mode support in iwlagn?
Date: Thu, 31 May 2012 11:20:49 +0200
Message-ID: <4932187.SWLxM4x7cN@flexo> (sfid-20120531_112309_153126_321CFF8F)
In-Reply-To: <1338455399.7328.0.camel@jlt3.sipsolutions.net>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be> <3093264.LxkCudZSCQ@sylvesterjr.cmi.ua.ac.be> <1338455399.7328.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thursday 31 May 2012 11:09:59 Johannes Berg wrote:
> Please don't top-post.
> 
> On Thu, 2012-05-31 at 11:03 +0200, Erwin Van de Velde wrote:
> > What is the reasoning behind it? Why provide it for some wireless NICs and 
not 
> > for others? Seems quite odd for me and features like Internet sharing over 
> > wireless are not that exotic, are they?
> 
> This features requires extensive testing, space in the firmware that not
> all devices have, integration, etc. It's not trivial to port to
> different devices.

It certainly is not, but you can get some help from the software mac with that 
regard. Since your device is capable of beaconing for P2P and GO modes, 
Erwin's question is perfectly legitimate with respect to AP support. I suppose 
that you could get it working without too much firmware work.

At the same time, since Intel's iwlwifi series are targetted at the laptop 
market, and not AP/router solutions, it certainly was not in a roadmap to get 
AP mode supported. Apart from pleasing people, that won't make you sell more 
adapters.

My 2 cents.
--
Florian

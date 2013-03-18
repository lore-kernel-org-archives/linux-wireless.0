Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37709 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab3CRSU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 14:20:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UHefv-0003dL-M5
	for linux-wireless@vger.kernel.org; Mon, 18 Mar 2013 19:20:47 +0100
Received: from 213.48.13.39 ([213.48.13.39])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 19:20:47 +0100
Received: from vishnu.kopparapu by 213.48.13.39 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 19:20:47 +0100
To: linux-wireless@vger.kernel.org
From: vishnu <vishnu.kopparapu@gmail.com>
Subject: Re: problem connecting to AP on new kernel (disassociating continuously after associating ) . Can some one please comment on the issue I am facing
Date: Mon, 18 Mar 2013 18:20:09 +0000 (UTC)
Message-ID: <loom.20130318T191350-236@post.gmane.org> (sfid-20130318_192032_281310_A6ECA4BE)
References: <loom.20130315T140953-940@post.gmane.org> <5144A184.1060900@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jussi Kivilinna <jussi.kivilinna@...> writes:

> 
> On 15.03.2013 15:29, vishnu wrote:
> > Hello all,
> > 
> > driver used : rtl8192cu
> > 
> > When I tested with my linux kernel 3.0 , I didn't have any problems 
connecting 
> > to AP. But with kernel 3.6.8 , I had a problem . When I tested with 3.7.8 
also I 
> > am facing the same problem. This is the latest kernel used by latest release 
of 
> > buildroot , so I didn't test any kernels after that version.
> > 
> > The authentication and association are fine but from some reason it is 
> > disassociating after that and it keeps repeating it and it never connects to 
the 
> > AP.
> > 
> 
> Have you tested this patch: http://marc.info/?l=linux-
wireless&m=136318849815054&w=2
> 
> It solves re-association issues that rtl8192cu had.
> 
> -Jussi
> 
> 

Hello Jussi,

I have applied the patch to kernel 3.7.8 and it doesn't fix my issue. I have 
started testing the latest 3.9.0-rc2 version. I will let you know once I have 
tested.

Thanks,
Vishnu.





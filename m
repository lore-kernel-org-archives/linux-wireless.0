Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:47244 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758925AbZFJPAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 11:00:25 -0400
Subject: Re: Cross compiling libnl, iw, crda and friends
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Samuel Ortiz <samuel@sortiz.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1244587813.2628.10.camel@sortiz-mobl>
References: <1244577286.12185.7.camel@jdl-desktop>
	 <1244587813.2628.10.camel@sortiz-mobl>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 09:59:55 -0500
Message-Id: <1244645995.14768.6.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-10 at 00:50 +0200, Samuel Ortiz wrote:
> Hi Jon,
> 
> On Tue, 2009-06-09 at 14:54 -0500, Jon Loeliger wrote:
> > Guys,
> > 
> > Am I missing an obvious solution to cross compiling libnl, iw,
> > the crda and related friends?
> > 
> Unless you're looking for a quick and easy fix to build some
> one-shot demo image for your target, you may want to start looking
> at cross platform build systems, like openembedded, poky or maybe
> openwrt.
> 
> Cheers,
> Samuel.

Hi folks,

Thanks for the feedback.   I totally get the cross-compilation
environment thing, thanks.  I have all that set up.  (PowerPC,
LTIB, powerpc-e300-linux-gnu-, etc.)

My questions really pertain to the actual configure and makefile
mechanisms in these packages themselves.  For example, it seems
to me that the whole pkg-config mechanism as used in these
makefiles doesn't distinguish between the build and target include
directories.

I'll try and work up some patches.

Thanks,
jdl



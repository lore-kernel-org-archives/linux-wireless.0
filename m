Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54681
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXBRL2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Feb 2007 06:28:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: IPW2200 monitoring FW broken
Date: Sun, 18 Feb 2007 12:27:36 +0100
Cc: linux-wireless@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
References: <200702151840.16963.mb@bu3sch.de> <45D7CAD9.5030602@gentoo.org>
In-Reply-To: <45D7CAD9.5030602@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702181227.37020.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 18 February 2007 04:41, Daniel Drake wrote:
> Michael Buesch wrote:
> > Is IPW2200 monitoring FW still broken?
> > I miss huge amounts of packets when I try to monitor
> > some traffic.
> 
> I had the same problem with ipw2200 once. I lost the hardware before I 
> had a chance to dig into it, but then noticed ipw3945 on my laptop doing 
> the same thing.
> 
> I've now narrowed it down a bit further: if i load ipw3945/ipw3945d and 
> associate to a network in managed mode before switching to monitor mode, 
>   then when monitoring I only see about 1/4 of all traffic.
> 
> But, if I load the driver and go straight into monitor mode, things are 
> peachy. Maybe the same thing is happening for ipw2200?

I went straight into monitor mode.

-- 
Greetings Michael.

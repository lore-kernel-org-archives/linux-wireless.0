Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.iad.emailsrvr.com ([207.97.245.116]:42995 "EHLO
	smtp116.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbXBREJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 23:09:39 -0500
Message-ID: <45D7CAD9.5030602@gentoo.org>
Date: Sat, 17 Feb 2007 22:41:13 -0500
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
Subject: Re: IPW2200 monitoring FW broken
References: <200702151840.16963.mb@bu3sch.de>
In-Reply-To: <200702151840.16963.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Is IPW2200 monitoring FW still broken?
> I miss huge amounts of packets when I try to monitor
> some traffic.

I had the same problem with ipw2200 once. I lost the hardware before I 
had a chance to dig into it, but then noticed ipw3945 on my laptop doing 
the same thing.

I've now narrowed it down a bit further: if i load ipw3945/ipw3945d and 
associate to a network in managed mode before switching to monitor mode, 
  then when monitoring I only see about 1/4 of all traffic.

But, if I load the driver and go straight into monitor mode, things are 
peachy. Maybe the same thing is happening for ipw2200?

Daniel


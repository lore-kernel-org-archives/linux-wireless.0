Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53315
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030426AbXBOSLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 13:11:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: IPW2200 monitoring FW broken
Date: Thu, 15 Feb 2007 19:10:59 +0100
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
References: <200702151840.16963.mb@bu3sch.de> <45D48BDE.4070708@linux.intel.com>
In-Reply-To: <45D48BDE.4070708@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702151910.59609.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 February 2007 17:35, James Ketrenos wrote:
> Michael Buesch wrote:
> > Is IPW2200 monitoring FW still broken?
> > I miss huge amounts of packets when I try to monitor
> > some traffic.
> > 
> > I'm using current wireless-2.6 + v3.0 firmware.
> > 
> > Using two antennas.
> > 
> 
> What type of frames?  Data or management & control?

Well, I saw beacons from my AP getting lost an I immediately gave up.

> If you use wireshark to capture,

I do.

> you can't update the packet capture  
> window or you'll lose packets; but you should be able to get them all if 
> you're doing a tethereal > somefile or if you turn off the update of the 
> main window.

"update of the packet capture window". What's that?
I started a simple traffic monitoring in wireshark. Nothing fancy.

> I'm not sure if it can capture control frames or not.  I seem to recall 
> it getting some ACK frames but I don't think it was passing up all of 
> them, or if it ever passed up the CTS frames.  But you should be getting 
> the bulk of the data frames.
> 
> Yi -- do you recall what the ipw2200 firmware would pass up?

It never passed up ACK frames for me. But that's ok.

-- 
Greetings Michael.

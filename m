Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39111
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030725AbXBOTUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:20:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: IPW2200 monitoring FW broken
Date: Thu, 15 Feb 2007 20:20:27 +0100
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
References: <200702151840.16963.mb@bu3sch.de> <200702151910.59609.mb@bu3sch.de> <45D49BDA.30402@linux.intel.com>
In-Reply-To: <45D49BDA.30402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702152020.28131.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 February 2007 18:43, James Ketrenos wrote:
> Michael Buesch wrote:
> > On Thursday 15 February 2007 17:35, James Ketrenos wrote:
> >> you can't update the packet capture  
> >> window or you'll lose packets; but you should be able to get them all if 
> >> you're doing a tethereal > somefile or if you turn off the update of the 
> >> main window.
> > 
> > "update of the packet capture window". What's that?
> > I started a simple traffic monitoring in wireshark. Nothing fancy.
> 
> In the 'Capture Options', the only option you can set is 'Hide capture 
> info dialog'.  If you turn on 'Update list of packets in real time' or 
> 'Automatic scrolling in live capture', packets get dropped.  I don't 
> know if its a libpcap queue that fills up, if it starves the NIC, or 
> what--but having those turned on greatly reduces the # of packets you'll 
> capture.

Hm, yeah. I have that turned on. But I don't see this issue
when monitoring with bcm43xx hardware.

-- 
Greetings Michael.

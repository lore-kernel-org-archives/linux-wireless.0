Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45412
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030778AbXBOT51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:57:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: IPW2200 monitoring FW broken
Date: Thu, 15 Feb 2007 20:57:11 +0100
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
References: <200702151840.16963.mb@bu3sch.de> <200702152020.28131.mb@bu3sch.de> <45D4A175.8060207@linux.intel.com>
In-Reply-To: <45D4A175.8060207@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702152057.11195.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 February 2007 19:07, James Ketrenos wrote:
> Michael Buesch wrote:
> > On Thursday 15 February 2007 18:43, James Ketrenos wrote:
> >> Michael Buesch wrote:
> >>> On Thursday 15 February 2007 17:35, James Ketrenos wrote:
> >>>> you can't update the packet capture  
> >>>> window or you'll lose packets; but you should be able to get them all if 
> >>>> you're doing a tethereal > somefile or if you turn off the update of the 
> >>>> main window.
> >>> "update of the packet capture window". What's that?
> >>> I started a simple traffic monitoring in wireshark. Nothing fancy.
> >> In the 'Capture Options', the only option you can set is 'Hide capture 
> >> info dialog'.  If you turn on 'Update list of packets in real time' or 
> >> 'Automatic scrolling in live capture', packets get dropped.  I don't 
> >> know if its a libpcap queue that fills up, if it starves the NIC, or 
> >> what--but having those turned on greatly reduces the # of packets you'll 
> >> capture.
> > 
> > Hm, yeah. I have that turned on. But I don't see this issue
> > when monitoring with bcm43xx hardware.
> > 
> 
> I had read about it on a libpcap forum a while ago (it wasn't an ipw2x00 
> issue that was being discussed); I never looked into the root cause of 
> it since I figured it was 'just the way it was'.
> 
> If you turn it off, does the # of packets captured improve w/ the ipw2200?

No. packet (beacon) sequence numbers from my AP are:
201, 202, 204, 205, 206, 209...
Just as an example.

-- 
Greetings Michael.

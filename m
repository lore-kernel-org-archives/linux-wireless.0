Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:37215 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030381AbXBOSDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 13:03:33 -0500
Message-ID: <45D48BDE.4070708@linux.intel.com>
Date: Thu, 15 Feb 2007 08:35:42 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
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
> 
> I'm using current wireless-2.6 + v3.0 firmware.
> 
> Using two antennas.
> 

What type of frames?  Data or management & control?

If you use wireshark to capture, you can't update the packet capture 
window or you'll lose packets; but you should be able to get them all if 
you're doing a tethereal > somefile or if you turn off the update of the 
main window.

I'm not sure if it can capture control frames or not.  I seem to recall 
it getting some ACK frames but I don't think it was passing up all of 
them, or if it ever passed up the CTS frames.  But you should be getting 
the bulk of the data frames.

Yi -- do you recall what the ipw2200 firmware would pass up?

James

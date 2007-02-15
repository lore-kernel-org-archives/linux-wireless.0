Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:39426 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030692AbXBOTL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 14:11:28 -0500
Message-ID: <45D49BDA.30402@linux.intel.com>
Date: Thu, 15 Feb 2007 09:43:54 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: Re: IPW2200 monitoring FW broken
References: <200702151840.16963.mb@bu3sch.de> <45D48BDE.4070708@linux.intel.com> <200702151910.59609.mb@bu3sch.de>
In-Reply-To: <200702151910.59609.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 15 February 2007 17:35, James Ketrenos wrote:
>> you can't update the packet capture  
>> window or you'll lose packets; but you should be able to get them all if 
>> you're doing a tethereal > somefile or if you turn off the update of the 
>> main window.
> 
> "update of the packet capture window". What's that?
> I started a simple traffic monitoring in wireshark. Nothing fancy.

In the 'Capture Options', the only option you can set is 'Hide capture 
info dialog'.  If you turn on 'Update list of packets in real time' or 
'Automatic scrolling in live capture', packets get dropped.  I don't 
know if its a libpcap queue that fills up, if it starves the NIC, or 
what--but having those turned on greatly reduces the # of packets you'll 
capture.

James

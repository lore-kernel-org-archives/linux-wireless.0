Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:53048 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbYJSXuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 19:50:19 -0400
Subject: Re: 10-17-2008 Build issues - Intel 3945abg - Ubuntu Intrepid
From: Myk Robinson <myk.robinson@kingdomcomputer.info>
Reply-To: myk.robinson@kingdomcomputer.info
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224258314.11187.1.camel@rc-desk>
References: <1224248117.28593.3.camel@mobileOne>
	 <1224258314.11187.1.camel@rc-desk>
Content-Type: text/plain
Date: Sun, 19 Oct 2008 18:45:07 -0500
Message-Id: <1224459907.9743.1.camel@mobileOne> (sfid-20081020_015029_766006_E942D6C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is a dmesg log using the 10-18-2008 build on a Gateway M-6881
laptop with the intel 3945abg wifi.


http://pastebin.com/f2b96dfd3

I hope this helps get it sorted out. In the meantime, I will compile
today's build and see what happens.

THanks,

-- 
--
Myk Robinson
Computer Support Specialist
Kingdom Computer Solutions
http://www.kingdomcomputer.info
myk.robinson@kingdomcomputer.info
(731) 616.5030


On Fri, 2008-10-17 at 08:45 -0700, reinette chatre wrote:
> On Fri, 2008-10-17 at 07:55 -0500, Myk Robinson wrote:
> > Hello-
> > 
> > Used your driver package in Ubuntu Hardy with no trouble at all. Testing
> > the Intrepid beta now. Before today, using the compat-wireless driver
> > for kernel 2.6.27, networkmanager showed all devices grayed out and
> > iwlist scan would not work. Today's driver release has allowed me to
> > connect, but still drops the connection with intel 2945abg. Also, it
> > causes the touchpad to lose sync when the connection is dropped.
> > 
> > Here is a pastebin containing some dmesg info that might be helpful.
> > 
> > http://pastebin.com/f286ee42c
> > 
> 
> The log shows some firmware errors. Could you please follow the steps on
> http://intellinuxwireless.org/?n=fw_error_report to help us find the
> cause of the problem?
> 
> Thanks
> 
> Reinette
> 



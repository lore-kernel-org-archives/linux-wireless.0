Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:52038 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbYJRNdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 09:33:36 -0400
Subject: Re: 10-17-2008 Build issues - Intel 3945abg - Ubuntu Intrepid
From: Myk Robinson <myk.robinson@kingdomcomputer.info>
Reply-To: myk.robinson@kingdomcomputer.info
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224279527.11187.58.camel@rc-desk>
References: <1224248117.28593.3.camel@mobileOne>
	 <1224258314.11187.1.camel@rc-desk>  <1224271086.6775.8.camel@mobileOne>
	 <1224279527.11187.58.camel@rc-desk>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 08:33:29 -0500
Message-Id: <1224336809.6934.1.camel@mobileOne> (sfid-20081018_153341_733710_6FC30EAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-17 at 14:38 -0700, reinette chatre wrote:
> On Fri, 2008-10-17 at 14:18 -0500, Myk Robinson wrote:
> > Sure will
> > 
> > Just curious, what can you tell me about the dmesg I posted? I don't
> > understand much of it, that is just what I have learned to run right
> > after stuff happens :)
> 
> The log shows that the driver is loaded/unloaded a couple of times -
> probably by wpa_supplicant. The details surrounding the error will
> become clear when we get more debugging.
> 
> 
> > As for the module, can you tell me how to autoload it with those
> > parameters? Or should i jsut upon booting rmmod the module then reload
> > it with your suggested parameters?
> 
> You could ask modprobe to load the module with parameters. perhaps
> in /etc/modprobe.d/options. You could also use the rmmod/modprobe after
> system reboot as you suggested. 
> 
> Reinette

Here is some more output from dmesg with the module parameters loaded.
SOrry if there is some output that you don't need in there too.

http://pastebin.com/m47cf17c9

-- 
--
Myk Robinson
Computer Support Specialist
Kingdom Computer Solutions
http://www.kingdomcomputer.info
myk.robinson@kingdomcomputer.info
(731) 616.5030


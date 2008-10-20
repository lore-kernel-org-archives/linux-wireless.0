Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:14727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbYJTXbj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 19:31:39 -0400
Subject: Re: 10-17-2008 Build issues - Intel 3945abg - Ubuntu Intrepid
From: reinette chatre <reinette.chatre@intel.com>
To: "myk.robinson@kingdomcomputer.info"
	<myk.robinson@kingdomcomputer.info>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224336809.6934.1.camel@mobileOne>
References: <1224248117.28593.3.camel@mobileOne>
	 <1224258314.11187.1.camel@rc-desk>  <1224271086.6775.8.camel@mobileOne>
	 <1224279527.11187.58.camel@rc-desk>  <1224336809.6934.1.camel@mobileOne>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 16:31:55 -0700
Message-Id: <1224545515.8698.5.camel@rc-desk> (sfid-20081021_013143_119966_1AACCC1B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-10-18 at 06:33 -0700, Myk Robinson wrote:
> On Fri, 2008-10-17 at 14:38 -0700, reinette chatre wrote:
> > On Fri, 2008-10-17 at 14:18 -0500, Myk Robinson wrote:
> > > Sure will
> > >
> > > Just curious, what can you tell me about the dmesg I posted? I don't
> > > understand much of it, that is just what I have learned to run right
> > > after stuff happens :)
> >
> > The log shows that the driver is loaded/unloaded a couple of times -
> > probably by wpa_supplicant. The details surrounding the error will
> > become clear when we get more debugging.
> >
> >
> > > As for the module, can you tell me how to autoload it with those
> > > parameters? Or should i jsut upon booting rmmod the module then reload
> > > it with your suggested parameters?
> >
> > You could ask modprobe to load the module with parameters. perhaps
> > in /etc/modprobe.d/options. You could also use the rmmod/modprobe after
> > system reboot as you suggested.
> >
> > Reinette
> 
> Here is some more output from dmesg with the module parameters loaded.
> SOrry if there is some output that you don't need in there too.
> 
> http://pastebin.com/m47cf17c9

Your driver is not compiled with debugging support.Could you please
recompile the driver to support debugging (CONFIG_IWL3945_DEBUG) and
rerun your test?

Thank you

Reinette


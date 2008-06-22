Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:58968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYFVXdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 19:33:12 -0400
Subject: Re: building mac80211
From: John George Wright <john@limongrafica.com>
Reply-To: john@limongrafica.com
To: Ian Schram <ischram@telenet.be>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <485D225A.8090604@telenet.be>
References: <1214042097.12100.5.camel@Johnardbell>
	 <200806211156.47246.mb@bu3sch.de>  <485D225A.8090604@telenet.be>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 00:33:04 +0100
Message-Id: <1214177584.6687.3.camel@Johnardbell> (sfid-20080623_013322_302147_0F95A522)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks so much for your quick response. I have now got it working :)

John

On Sat, 2008-06-21 at 17:46 +0200, Ian Schram wrote:
> 
> Michael Buesch wrote:
> > On Saturday 21 June 2008 11:54:57 John George Wright wrote:
> >> Hi,
> >>
> >> I'm very new to the linux operating systems so please treat me as a
> >> child.
> >>
> >> I have an Intel PRO/Wireless 3945ABG built into my laptop and I am
> >> trying to adapt the latest version of ubuntu to work with it. I followed
> >> some online instructions and downloaded the mac80211-10.0.4 tar,
> >> unpacked it and used this command:
> >>
> >> make SHELL=/bin/bash
> >>
> >> but received the following error:
> >>
> >> Building modified version in 'modified/' directory:
> >> Copying modified/ from origin/...done
> >> Applying patches and scripts from pending/.
> >>  + Applying: pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch
> >> 	From 26e77a5fef845edcb5c27db52f413e7558db0e20 Mon Sep 17 00:00:00 2001
> >> scripts/generate_modified: line 57: patch: command not found
> >> -----patch failure output-----
> >>
> >> pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch failed.
> >> Terminating.
> >> If patch or script failed, check pre/ and post/ for current stage.
> >> make: *** [modified] Error 1
> >>
> >> Would you have any idea where I'm going wrong?
> > 
> > apt-get install patch
> > 
> 
> apt-getting patch will indeed solve that error, but will surely generate a different one a bit later in the
> process.
> 
> If you have the latest version of ubuntu, you probably don't want to mess with the packages
> at intellinuxwireless.org. as I understand it, they are deprecated for everything except older
> kernels, from before iwlwifi was merged.
> 
> I think 8.04 ubuntu has a 2.6.24 kernel, so most likely it already has iwlwifi. You probaby want to
> check that you have the firmware installed. in /lib/firmware.
> 
> if you really want the latest driver the compat wireless project is probably the way to go.
> http://wireless.kernel.org/download/compat-wireless-2.6/


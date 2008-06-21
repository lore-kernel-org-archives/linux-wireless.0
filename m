Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49942 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYFUJ5J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 05:57:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: john@limongrafica.com
Subject: Re: building mac80211
Date: Sat, 21 Jun 2008 11:56:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <1214042097.12100.5.camel@Johnardbell>
In-Reply-To: <1214042097.12100.5.camel@Johnardbell>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806211156.47246.mb@bu3sch.de> (sfid-20080621_115714_062228_04216DCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 June 2008 11:54:57 John George Wright wrote:
> Hi,
> 
> I'm very new to the linux operating systems so please treat me as a
> child.
> 
> I have an Intel PRO/Wireless 3945ABG built into my laptop and I am
> trying to adapt the latest version of ubuntu to work with it. I followed
> some online instructions and downloaded the mac80211-10.0.4 tar,
> unpacked it and used this command:
> 
> make SHELL=/bin/bash
> 
> but received the following error:
> 
> Building modified version in 'modified/' directory:
> Copying modified/ from origin/...done
> Applying patches and scripts from pending/.
>  + Applying: pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch
> 	From 26e77a5fef845edcb5c27db52f413e7558db0e20 Mon Sep 17 00:00:00 2001
> scripts/generate_modified: line 57: patch: command not found
> -----patch failure output-----
> 
> pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch failed.
> Terminating.
> If patch or script failed, check pre/ and post/ for current stage.
> make: *** [modified] Error 1
> 
> Would you have any idea where I'm going wrong?

apt-get install patch

-- 
Greetings Michael.

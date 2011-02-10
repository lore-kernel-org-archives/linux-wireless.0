Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:48848 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1BJUHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 15:07:41 -0500
Subject: Re: SSB AI support code ([RFC] v2)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297367556.15805.79.camel@dev.znau.edu.ua> (sfid-20110210_210037_888283_50681D32)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <4D5320AA.5020405@lwfinger.net> <1297315457.12795.40.camel@dev.znau.edu.ua>
	 (sfid-20110210_063153_817778_FFFFFFFFF46A15B5)  <1297333256.30218.10.camel@maggie>
	 <1297359641.15805.38.camel@dev.znau.edu.ua>
	 (sfid-20110210_184827_887841_41FA745D)  <1297361481.30218.31.camel@maggie>
	 <1297362251.15805.51.camel@dev.znau.edu.ua>
	 (sfid-20110210_193159_907950_6C4B7BA8)  <1297363781.30218.37.camel@maggie>
	 <1297367556.15805.79.camel@dev.znau.edu.ua>
	 (sfid-20110210_210037_888283_50681D32)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 21:07:36 +0100
Message-ID: <1297368456.30218.40.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-10 at 21:52 +0200, George Kashperko wrote: 
> But yet again not like im scared of amount of if/else stuff this will
> introduce (most of it could be hidden with proper inliners anyway). Just

I don't think the amount of conditionals will be much bigger than the 
amount in your current approach. Especially not if you use ops.

> > I have no idea. You could probably look at brcm80211 for starters?
> > 
> Already done with that, unfortunately PCI_VENDOR_ID_BROADCOM with
> dev_ids 0x4357/0x4353/0x4727 gives me no clue if they are SB or AI
> based.

They are all AI based.

-- 
Greetings Michael.


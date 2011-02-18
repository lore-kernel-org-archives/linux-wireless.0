Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:15471 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1BRXvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 18:51:10 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022500.msg
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:50:32 +0200
Subject: Re: [RFC] AI support (13/14 ssb add AI support)
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1298071637.23801.40.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297981882.23381.38.camel@dev.znau.edu.ua>
	 (sfid-20110217_233956_707110_FFFFFFFFBE33FFA6)  <1298069145.23801.29.camel@maggie>
	 <1298070443.25739.23.camel@dev.znau.edu.ua>
	 (sfid-20110219_001605_010946_FFFFFFFFA70C4DCA)  <1298071637.23801.40.camel@maggie>
Content-Type: text/plain
Date: Sat, 19 Feb 2011 01:42:29 +0200
Message-Id: <1298072549.25739.50.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Oh, wait a second right here. That's not how Linux development works.
> We want the technically superior solution, not just something that
> works to get stuff working no matter what.
> 
> If your patchset works, that's pretty cool. So thanks a lot for getting
> something to the users that works. Nothing stops distributions from
> picking up those patches and distributing it to endusers.
> That doesn't mean we have to adopt it to the mainline, though.
Well, my point here is somewhat different. As I've wrote earlier few
days ago till the time when (or better say if?) we get some tech. docs
on AI, software wise it look very much similat to SB.
Yes, it might be not SSB at all, and might more AMBA or some other
hardware solution. 

Actually, software wise at current level of knowledge that goes from
sources available it pretty much the same backplanes where whole num of
registers used to control bus itself 4 for SSB and 2 for AI (I omit here
regs used for identification but they are more chipcommon core ones'
rather than bus property, and also omit those we don't use at all cause
we don't need em or just dont know wth they are).

There are much more differences between PCI and PCIE but we still dont
have two different buses, and here honestly I don't know if PCI project
was forked when PCIE support was added or not.

I wish Broadcom could get us more tech. details on AI or if not then
just name it SSB2 to avoid arguing on confusion caused by <SSB AI> ;)


Have nice day,
George



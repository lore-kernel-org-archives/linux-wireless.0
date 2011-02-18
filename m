Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:15286 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1BRXQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 18:16:00 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022484.msg
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:15:22 +0200
Subject: Re: [RFC] AI support (13/14 ssb add AI support)
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	driverdevel <devel@driverdev.osuosl.org>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
In-Reply-To: <1298069145.23801.29.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297981882.23381.38.camel@dev.znau.edu.ua>
	 (sfid-20110217_233956_707110_FFFFFFFFBE33FFA6)  <1298069145.23801.29.camel@maggie>
Content-Type: text/plain
Date: Sat, 19 Feb 2011 01:07:23 +0200
Message-Id: <1298070443.25739.23.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> On Fri, 2011-02-18 at 00:31 +0200, George Kashperko wrote: 
> > +#define SSB_AI_BASE			0x18100000U /* base for AI registers */
> 
> #define MOON_EARTH_BASE 1337
> 
> That probably is my major point against this patchset. It just
> merges things that don't belong to each other.
> Is this the base on moon or earth?
> If it's the earth base, why the hell do we prefix the define with MOON?
> 
> That naming confusion continues throughout the whole patchset.
> 
> SSB is end of life, so we should not try to support the new AI hardware
> by making SSB AI aware. Just fork SSB and let legacy SSB die as the
> existing hardware dies. It deserves it. Mercy killing for software!
> 
> _Currently_ it may look like a good idea to use one software base
> for the two busses, but the cruft will hurt you in the future.
> And the future begins one day after this hack was merged.
> 
Well, if that was year ago I would agree with you. Now I doubt it.
Starting from the clean page means another months of no support for
AI-based hw. Going cp ssb bcmai; sed s/ssb/bcmai way will make whole
messup. Making AI over SSB causing confusion.
Either way here for me looks wrong, but among them I would better choose
on going 1+3 rather just 1st one alone.
Ah, well, there might is another 4th way to go if Broadcom will finally
support their bus with their brand code but honestly (no offence to
Broadcom here, just my personal subjective opinion) I dont think I will
be happy to see this code after all that I've already seen.

Clean page is the best. The best is the enemy for the good.

Have nice day,
George



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:15335 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1BRXYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 18:24:20 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022487.msg
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:23:42 +0200
Subject: Re: [RFC] AI support (2/14 ssb helpers)
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1298068149.23801.16.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297980484.23381.4.camel@dev.znau.edu.ua>
	 (sfid-20110217_231646_647052_FFFFFFFFEFB25F2A)  <1298068149.23801.16.camel@maggie>
Content-Type: text/plain
Date: Sat, 19 Feb 2011 01:15:45 +0200
Message-Id: <1298070945.25739.31.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> On Fri, 2011-02-18 at 00:08 +0200, George Kashperko wrote: 
> > 	const struct ssb_bus_ops *ops;
> > +	const struct ssb_bus_helpers *helpers;
> 
> Uhm, well. "helpers"... . Seems like a pretty generic term.
> 
> I think this is still violating abstraction layering. Not as much
> as your previous attempt, but still...
> 
> You're putting the ops structure that is supposed to abstract
> the ssb bus into the ssb_device data structure. That should ring a bell.
> 
Reconsidered it already while arranging patches for Openwrt (the reason
helpers were in device struct was to speedup access but these aint
called often therefore they are in ssb_bus now). Also moved
chipco.chipid into ssb_bus struct, could rename it also right away if
only I get up fresh and with good idea how to name it properly or maybe
you will suggest nice one. 

Have nice day,
George



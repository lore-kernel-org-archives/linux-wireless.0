Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:15413 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab1BRXg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 18:36:26 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022493.msg
	for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:35:47 +0200
Subject: Re: [RFC] AI support (2/14 ssb helpers)
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1298071777.23801.42.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
	 <1297980484.23381.4.camel@dev.znau.edu.ua>
	 (sfid-20110217_231646_647052_FFFFFFFFEFB25F2A)  <1298068149.23801.16.camel@maggie>
	 <1298070945.25739.31.camel@dev.znau.edu.ua>
	 (sfid-20110219_002424_959914_4197FDC7)  <1298071777.23801.42.camel@maggie>
Content-Type: text/plain
Date: Sat, 19 Feb 2011 01:27:48 +0200
Message-Id: <1298071668.25739.35.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I should probably note that in my opinion ssb_bus is not the right place
> to put ops that are supposed to abstract the SSB bus, too. ;)
> _No_ SSB structure is the right place to put an ops pointer that is
> supposed to abstract the SSB bus.

Well, can't put it over ssb_bus struct yet :)

Have nice day,
George



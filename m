Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38310 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392AbYIMPk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 11:40:58 -0400
Message-ID: <48CBDF0B.5080303@lwfinger.net> (sfid-20080913_174103_590206_2E8BA8EE)
Date: Sat, 13 Sep 2008 10:40:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>, chunkeey@web.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] p54: Fix sparse warnings
References: <48cab1e3.m0lac7LoL3DFxIu6%Larry.Finger@lwfinger.net> <200809122036.03553.mb@bu3sch.de> <48CABA84.2060404@lwfinger.net> <200809131440.01505.mb@bu3sch.de>
In-Reply-To: <200809131440.01505.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Friday 12 September 2008 20:52:52 Larry Finger wrote:
>> No, it won't avoid any casts. The program uses the data area 7 times 
>> in native-cpu order, once as be32, and once in little-endian order 
> 
> Is the native use correct? Smells fishy.

It does to me as well. I just got a copy of Intersil's data sheet for
the MAC and everything looks little endian, but until we get a tester
with a big-endian machine, we won't know. So far, no volunteers have
come forward.

Larry




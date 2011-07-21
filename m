Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hhlx01.visionsystems.de ([62.145.30.242]:54142 "EHLO
	mail.visionsystems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1GUPJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:09:25 -0400
Message-ID: <4E28411B.5050807@visionsystems.de> (sfid-20110721_170928_465891_BD5F3B7A)
Date: Thu, 21 Jul 2011 17:09:15 +0200
From: Yegor Yefremov <yegor_sub1@visionsystems.de>
Reply-To: yegor_sub1@visionsystems.de
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: add libnl-3.0 support
References: <4DB91BB9.2080405@visionsystems.de>	 <4E26ABAA.8050404@visionsystems.de> (sfid-20110720_125228_946659_FC4D17FF) <1311190027.15152.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1311190027.15152.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 20.07.2011 21:27, schrieb Johannes Berg:
> On Wed, 2011-07-20 at 12:19 +0200, Yegor Yefremov wrote:
>
>>> +ifeq ($(NL3FOUND),Y)
>>> +CFLAGS += -DCONFIG_LIBNL20
>>> +LIBS += -lnl-genl
>>> +NLLIBNAME = libnl-3.0
>>> +endif
> I'd prefer if you did -DCONFIG_LIBNL30 and added the correct ifdefs
> (please make it #if defined(...) || defined(...))  

O.K. I made the changes (see v2).  The code excluded, if LIBNL20 is detected, was actually libnl 1.x compatibility code and not libnl 2.0 compatibility code. Do I see it right?

Yegor


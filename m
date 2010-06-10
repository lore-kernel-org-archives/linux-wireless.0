Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50145 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0FJStt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 14:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <1275600737.2091.32332.camel@rchatre-DESK>
References: <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
	<1274726029.2091.15160.camel@rchatre-DESK>
	<1274738896.2091.15438.camel@rchatre-DESK>
	<1274830187.2091.17034.camel@rchatre-DESK>
	<1275600737.2091.32332.camel@rchatre-DESK>
Date: Fri, 11 Jun 2010 00:19:48 +0530
Message-ID: <AANLkTinfoyhEyFjxReR6Oza7r_AQhcyMlpaXYB4ZjjlU@mail.gmail.com>
Subject: Re: iwl3945 bug in 2.6.34
From: Satish Eerpini <eerpini@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have applied the patches to the 2.6.34 kernel, my machine has been
up for 20 hours now, there is nothing in the dmesg either, dmesg |
grep wlan0 just gives this :

ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: deauthenticating from 00:1b:da:2a:a1:53 by local choice (reason=3)
wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
wlan0: authenticated
wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
wlan0: deauthenticating from 00:1b:da:2a:a1:53 by local choice (reason=3)
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: deauthenticating from 00:1b:da:2a:a1:53 by local choice (reason=3)
wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
wlan0: authenticated
wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
wlan0: associated
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
wlan0: no IPv6 routers present
wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
wlan0: authenticated
wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
wlan0: associated
wlan0: authenticate with 00:1b:da:2a:a1:53 (try 1)
wlan0: authenticated
wlan0: associate with 00:1b:da:2a:a1:53 (try 1)
wlan0: RX AssocResp from 00:1b:da:2a:a1:53 (capab=0x411 status=0 aid=1)
wlan0: associated

so I think after applying the patches, things have been working fine.

Cheers
Satish

-- 
http://satisheerpini.net

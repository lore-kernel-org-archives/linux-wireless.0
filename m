Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1ENI1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 04:27:42 -0400
Subject: Re: iw connect syntax for wep
From: Johannes Berg <johannes@sipsolutions.net>
To: John Frankish <j-frankish@slb.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <654DF80AD31A344E93DBCC6280BD6DEF19352F42@NL0230MBX08N1.DIR.slb.com> (sfid-20110514_091121_246970_E2FF9308)
References: <654DF80AD31A344E93DBCC6280BD6DEF19352F42@NL0230MBX08N1.DIR.slb.com>
	 (sfid-20110514_091121_246970_E2FF9308)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 May 2011 10:27:39 +0200
Message-ID: <1305361659.3437.3.camel@jlt3.sipsolutions.net> (sfid-20110514_102747_082779_483E4E25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 07:01 +0000, John Frankish wrote:
> The iw documentation and "iw --help" states the following for establishing a wep connection:
> 
> iw wlan0 connect foo keys 0:abcde d:1:0011223344
> 
> What command syntax is supposed to be used when connecting to an ap using a single wep code consisting of 13 hex pairs?
> 
> "iw wlan0 connect ssid keys 1:00112233445566778899AABBCC" does not work

13 hex pairs isn't a valid key. WEP keys are either 5 or 10 bytes.

johannes


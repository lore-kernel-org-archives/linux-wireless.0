Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4572 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab3K3NzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 08:55:25 -0500
Message-ID: <5299EE21.6050304@broadcom.com> (sfid-20131130_145533_105243_B25B72FA)
Date: Sat, 30 Nov 2013 14:54:41 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Krzysztof Kolasa" <kkolasa@winsoft.pl>,
	linux-wireless@vger.kernel.org
Subject: Re: WARNING: CPU: 2 PID: 827 at net/wireless/sme.c:795
 cfg80211_roamed+0x97/0xa0 [cfg80211]()
References: <5298EA48.1050206@winsoft.pl> (
 sfid-20131129_204934_655986_57747678)
 <1385763288.5149.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1385763288.5149.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/13 23:14, Johannes Berg wrote:
> On Fri, 2013-11-29 at 20:26 +0100, Krzysztof Kolasa wrote:
>
>> cfg80211_roamed+0x97/0xa0 [cfg80211]
>> wl_bss_connect_done.isra.18+0xa3/0x1b0 [wl]
>> wl_notify_connect_status+0x176/0x340 [wl]
>
> Not sure why we should care about proprietary drivers ...

Even I am not sure ;-) There can be a couple of root causes, I guess. 
The bss was never given to cfg80211 or the bss has expired. It would be 
useful to find out why and share your findings on the more appropriate 
mailing list linux-wlan-client-support-list@broadcom.com as found on web 
page [1].

Gr. AvS

[1] http://www.broadcom.com/support/802.11/linux_sta.php


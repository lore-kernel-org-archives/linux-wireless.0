Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56461 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbZKYSWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 13:22:35 -0500
Subject: Re: ath9k and multiple ssids
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Ali Jelveh <jelveh@web.de>
In-Reply-To: <20091124174904.GA17305@jm.kir.nu>
Date: Wed, 25 Nov 2009 19:22:39 +0100
Cc: linux-wireless@vger.kernel.org
Message-Id: <597B75D5-987E-46D5-9994-0C7051E6DB71@web.de>
References: <4F794DBA-82EF-4254-A874-ADFF05287CF4@web.de> <D16ADE3A-61E2-4F46-ADD6-D3C8824A9BE9@web.de> <20091124174904.GA17305@jm.kir.nu>
To: Jouni Malinen <j@w1.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

thanks!! we're trying to get to hostapd v.0.7.0 will update when/if it  
works! :)

Ali
On 24.11.2009, at 18:49, Jouni Malinen wrote:

> On Mon, Nov 23, 2009 at 09:50:34PM +0100, Ali Jelveh wrote:
>
>> I'm trying to get multiple ssids to work with hostapd (2.6.31 kernel
>> and hostapd v0.6.9, driver=nl80211) thru adding a bss=wlan0_1 and
>> ssid=someothername to the config, I get an "Invalid BSSID mask"
>> error - so my question is: should this work? or isn't that feature
>> implemented in my current wireless driver?
>
> Please try with hostapd v0.7.0; 0.6.9 is way too old for many nl80211
> interface features. If you cannot get this working with 0.7.0, please
> send more verbose debug log from hostapd. Which MAC address does your
> card have?
>
> -- 
> Jouni Malinen                                            PGP id  
> EFC895FA


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47261 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933576AbZKXRtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:49:02 -0500
Date: Tue, 24 Nov 2009 19:49:04 +0200
From: Jouni Malinen <j@w1.fi>
To: Ali Jelveh <jelveh@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k and multiple ssids
Message-ID: <20091124174904.GA17305@jm.kir.nu>
References: <4F794DBA-82EF-4254-A874-ADFF05287CF4@web.de>
 <D16ADE3A-61E2-4F46-ADD6-D3C8824A9BE9@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <D16ADE3A-61E2-4F46-ADD6-D3C8824A9BE9@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 23, 2009 at 09:50:34PM +0100, Ali Jelveh wrote:

> I'm trying to get multiple ssids to work with hostapd (2.6.31 kernel
> and hostapd v0.6.9, driver=nl80211) thru adding a bss=wlan0_1 and
> ssid=someothername to the config, I get an "Invalid BSSID mask"
> error - so my question is: should this work? or isn't that feature
> implemented in my current wireless driver?

Please try with hostapd v0.7.0; 0.6.9 is way too old for many nl80211
interface features. If you cannot get this working with 0.7.0, please
send more verbose debug log from hostapd. Which MAC address does your
card have?

-- 
Jouni Malinen                                            PGP id EFC895FA

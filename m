Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57156 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161129Ab1FALlg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:41:36 -0400
Message-ID: <4DE6256B.80106@openwrt.org> (sfid-20110601_134140_044370_23D55EE3)
Date: Wed, 01 Jun 2011 13:41:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>	 <1306870354.29989.1.camel@jlt3.sipsolutions.net>	 <4DE543E2.9070600@openwrt.org>	 <1306872395.29989.3.camel@jlt3.sipsolutions.net>	 <4DE54E16.7000709@openwrt.org>	 <1306901843.3867.2.camel@jlt3.sipsolutions.net>	 <4DE61A11.1070708@openwrt.org>	 <1306926131.3867.8.camel@jlt3.sipsolutions.net>	 <4DE61FEA.60903@openwrt.org> <1306927838.3867.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1306927838.3867.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-01 1:30 PM, Johannes Berg wrote:
> On Wed, 2011-06-01 at 13:18 +0200, Felix Fietkau wrote:
>
>>  >>   >>    >>     >     I don't understand how you can rely on beacons for WDS.
>
>>  Oh, right. I'll send a follow-up patch that forces a WDS to also have an
>>  active AP interface before it's brought up.
>
> Hm, that might be sufficient, but what if the peer isn't sending
> beacons?
>
> Can't we add a station entry and then update it if we receive
> information from the peer? That'd be more compatible with others devices
> that don't necessarily have beacons with WDS, and then we wouldn't have
> to require it locally either (since realistically we might have to
> interoperate with those anyway?)
What other devices use WDS without beacons? So far I haven't seen any.

- Felix

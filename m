Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39562 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2FOIWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 04:22:05 -0400
Message-ID: <4FDAF096.200@qca.qualcomm.com> (sfid-20120615_102210_406026_BE06656B)
Date: Fri, 15 Jun 2012 11:21:42 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>  <1339228530.4539.0.camel@jlt3.sipsolutions.net>  <4FD3A936.8070600@broadcom.com>  <1339399952.4520.13.camel@jlt3.sipsolutions.net>  <4FD60369.80108@qca.qualcomm.com>  <1339425944.4520.27.camel@jlt3.sipsolutions.net>  <20120614193104.GD32257@tux> <1339748211.4512.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339748211.4512.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2012 11:16 AM, Johannes Berg wrote:
>> As for a name, I thought about it for a while and given that we have different
>> > "wireless" technologies -- bluetooth, NFC, naming this CONFIG_WIRELESS_EXPERT
>> > seemed odd, and given that our 802.11 framework is under cfg80211 naming it
>> > CONFIG_CFG80211_EXPERT seemed appropriate. But even if its under cfg80211
>> > perhaps something more explicit about the implications may be better, how
>> > about CONFIG_CFG80211_MAY_BREAK_CERTIFICATION ?
>
> Or you could just be explicit about it and call it
> CONFIG_WIRELESS_REGULATORY_BREAKAGE or something like that :-)

CONFIG_WIRELESS_CERTIFIED?

Kalle

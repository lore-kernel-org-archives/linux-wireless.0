Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43511 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2FOQKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 12:10:05 -0400
Message-ID: <4FDB5E52.1020608@qca.qualcomm.com> (sfid-20120615_181010_923131_5919712F)
Date: Fri, 15 Jun 2012 19:09:54 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com> <1339228530.4539.0.camel@jlt3.sipsolutions.net> <4FD3A936.8070600@broadcom.com> <1339399952.4520.13.camel@jlt3.sipsolutions.net> <4FD60369.80108@qca.qualcomm.com> <1339425944.4520.27.camel@jlt3.sipsolutions.net> <20120614193104.GD32257@tux> <1339748211.4512.6.camel@jlt3.sipsolutions.net> <4FDAF096.200@qca.qualcomm.com> <4FDB1740.60707@broadcom.com>
In-Reply-To: <4FDB1740.60707@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2012 02:06 PM, Arend van Spriel wrote:
> On 06/15/2012 10:21 AM, Kalle Valo wrote:
>> On 06/15/2012 11:16 AM, Johannes Berg wrote:
>>>> As for a name, I thought about it for a while and given that we have different
>>>>> "wireless" technologies -- bluetooth, NFC, naming this CONFIG_WIRELESS_EXPERT
>>>>> seemed odd, and given that our 802.11 framework is under cfg80211 naming it
>>>>> CONFIG_CFG80211_EXPERT seemed appropriate. But even if its under cfg80211
>>>>> perhaps something more explicit about the implications may be better, how
>>>>> about CONFIG_CFG80211_MAY_BREAK_CERTIFICATION ?
>>>
>>> Or you could just be explicit about it and call it
>>> CONFIG_WIRELESS_REGULATORY_BREAKAGE or something like that :-)
>>
>> CONFIG_WIRELESS_CERTIFIED?
> 
> That one looks familiar ;-)

Sorry, did you suggest that already? I missed that. I guess I need to
start organising my email better :)

Kalle

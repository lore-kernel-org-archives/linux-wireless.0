Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53431 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2LMF5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 00:57:18 -0500
Message-ID: <50C96E26.6040502@qca.qualcomm.com> (sfid-20121213_065722_185764_CE9B84E8)
Date: Thu, 13 Dec 2012 11:26:54 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
References: <1354880763-12309-1-git-send-email-vthiagar@qca.qualcomm.com> <1354880763-12309-2-git-send-email-vthiagar@qca.qualcomm.com> <1355255841.9819.18.camel@jlt4.sipsolutions.net> <50C81331.9080304@qca.qualcomm.com> <1355311595.9708.2.camel@jlt4.sipsolutions.net> <50C95F06.9090702@qca.qualcomm.com> <20681.27637.559013.79620@gargle.gargle.HOWL>
In-Reply-To: <20681.27637.559013.79620@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thursday 13 December 2012 11:17 AM, Sujith Manoharan wrote:
> Vasanthakumar Thiagarajan wrote:
>> Here the white and black list are real white and black list.
>> The mac address listed under white list are allowed to connect
>> while the ones available on black are blocked unconditionally
>> from connection. If a station's mac is part of neither of the lists,
>> that needs to be notified which is missing now. It is not very clear
>> to me about how the notification needs to be done, is it through
>> NL80211_ATTR_CONN_FAILED_REASON in NL80211_CMD_CONN_FAILED or
>> there needs to be new command/attr?.
>
> What if an address is part of both the lists ? :)

This does not seem like a valid configuration. I think it
is up to the fw to decide, probably give a notification to the
user when a connection request is received from that station?.

Vasanth

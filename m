Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx76.mail.ru ([94.100.176.91]:54089 "EHLO mx76.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbZJ3Ulr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 16:41:47 -0400
Date: Fri, 30 Oct 2009 23:49:02 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <1647528315.20091030234902@mail.ru>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re[2]: ieee80211_tx_status: headroom too small
In-reply-To: <43e72e890910301303r67fea6b1m3e04b267aceec66b@mail.gmail.com>
References: <1094614475.20091030230028@mail.ru>
 <43e72e890910301303r67fea6b1m3e04b267aceec66b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Friday, October 30, 2009, 11:03:20 PM, Luis R. Rodriguez wrote:

>> ieee80211_tx_status: headroom too small
>> ieee80211_tx_status: headroom too small
>> ieee80211_tx_status: headroom too small
>>
>> The wireless (access point) works fine, though maybe not very
>> fast. However, this warning somehow bothers me. Is it important?
>> Does it mean something critical? Maybe I should just comment
>> it out in the code? I don't like syslog being filled up this
>> way...

> You're lucky it even worked on 2.6.25.

Yeah but... 2.6.25 is the kernel used in the latest official release
of OpenWRT and in OpenSuse 11.0 as well (which is still their latest
reasonable release, as of now, too)

Ok, I'll probably wait for some updates.

Nikolai ZHUBR

>   Luis



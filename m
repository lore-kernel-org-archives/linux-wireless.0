Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48936 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab3FGO0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 10:26:50 -0400
Message-ID: <51B1EDA8.10406@openwrt.org> (sfid-20130607_162653_694617_AD456FC5)
Date: Fri, 07 Jun 2013 16:26:48 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrdWIgS2ljacWEc2tp?= <moorray3@wp.pl>
CC: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: Re: [RFC 4/5] mac80211: enforce address verification on monitors
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl> <1370612179-24385-5-git-send-email-moorray3@wp.pl> <51B1E4F3.9020509@openwrt.org> <20130607160402.49ea16c3@north>
In-Reply-To: <20130607160402.49ea16c3@north>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-07 4:04 PM, Jakub Kiciński wrote:
> On Fri, 07 Jun 2013 15:49:39 +0200, Felix Fietkau wrote:
>> On 2013-06-07 3:36 PM, Jakub Kicinski wrote:
>>> From: Jakub Kicinski <kubakici@wp.pl>
>>> 
>>> Mac address of passive monitor have to treated
>>> the same as address any other interface because
>>> type of interface can be changed or monitor can
>>> be later put into active mode.
>> It can't. There's checks preventing that. I'd prefer to leave that part
>> of the code as it is, the MAC address for normal monitor interfaces
>> should be ignored completely.
> 
> I must have misread the code regarding active monitors then.
> Main motivation behind this patch was the first part though
> - user can change type of interface and once ignored address
> of monitor now becomes address of AP, sta etc. 
I'm pretty sure that switching from monitor to something else is also
not supported.

- Felix


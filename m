Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19198 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2FKPqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:46:24 -0400
Message-ID: <4FD612CA.1050604@qca.qualcomm.com> (sfid-20120611_174628_222726_8126DA28)
Date: Mon, 11 Jun 2012 18:46:18 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>   <1339228530.4539.0.camel@jlt3.sipsolutions.net>   <4FD3A936.8070600@broadcom.com>  <1339399952.4520.13.camel@jlt3.sipsolutions.net>  <4FD60369.80108@qca.qualcomm.com> <1339425944.4520.27.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339425944.4520.27.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 05:45 PM, Johannes Berg wrote:
> On Mon, 2012-06-11 at 17:40 +0300, Kalle Valo wrote:
> 
>> I would compare this with NL80211_TESTMODE, we don't want distributions
>> to enable that either. Of course nothing prevents distros to enable
>> CFG80211_EXPERT but we need to be active to make sure it's not enabled
>> (ie. check the distro configs and file bugs etc).
> 
> Right, but that's actually a feature. I see little value in a pretty
> much meaningless "EXPERT wireless" Kconfig symbol that only groups
> others.

Ah, I see.

> If, as Arend suggested, it actually has some meaning, then it
> may make more sense.

Yeah, I see your point.

FWIW I do see the value with CFG80211_EXPERT as it makes more difficult
for users to accidentally enable certain features. And it makes it
easier for us to search for distros which have CFG80211_EXPERT enabled.

Kalle

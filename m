Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2GRJSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 05:18:50 -0400
Message-ID: <50067F74.5000206@qca.qualcomm.com> (sfid-20120718_111854_024454_8C1EA697)
Date: Wed, 18 Jul 2012 12:18:44 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: support TX error rate notification
References: <1342579195-18521-1-git-send-email-c_tpeder@qca.qualcomm.com>  (sfid-20120718_044010_258914_265CE137) <1342594185.5310.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1342594185.5310.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/18/2012 09:49 AM, Johannes Berg wrote:
> On Tue, 2012-07-17 at 19:39 -0700, Thomas Pedersen wrote:
>> The ath6kl firmware can monitor a connection and report when a certain
>> TX failure threshold is crossed. Support this configuration and event
>> reporting on compatible firmwares.
>>
>> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
>> ---
>> v2:
>> 	endianness & formatting (Kalle)
>> v3:
>> 	report configured interval
>>
>> Kalle,
>>
>> Please cherry-pick "84f10708f73254878246772cead70a2eb6a123f2" from w-t HEAD to
>> support this.
> 
> I don't think you should cherry-pick patches, it makes them show up in
> the trees twice later.

Don't worry, I won't :)

I always merge from wireless-next once the cfg80211 patch is there. I
guess in very exceptional cases I could merge from your mac80211-next
tree, but I try to avoid that.

Kalle

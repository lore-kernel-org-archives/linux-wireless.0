Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62819 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759171Ab3D3IO2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 04:14:28 -0400
Received: from mailout-de.gmx.net ([10.1.76.2]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MQ9JV-1URqmQ1kcl-005FBU for
 <linux-wireless@vger.kernel.org>; Tue, 30 Apr 2013 10:14:25 +0200
Message-ID: <517F7D5B.6020005@rempel-privat.de> (sfid-20130430_101432_699403_EC269AD1)
Date: Tue, 30 Apr 2013 10:14:19 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] mac80211: add STBC flag for radiotap
References: <1367228024-17936-1-git-send-email-linux@rempel-privat.de>  <1367228024-17936-3-git-send-email-linux@rempel-privat.de>  (sfid-20130429_113400_548526_A3E50994) <1367230485.8289.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1367230485.8289.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 29.04.2013 12:14, schrieb Johannes Berg:
> On Mon, 2013-04-29 at 11:33 +0200, Oleksij Rempel wrote:
>
>> --- a/include/net/ieee80211_radiotap.h
>> +++ b/include/net/ieee80211_radiotap.h
>> @@ -269,6 +269,7 @@ enum ieee80211_radiotap_type {
>>   #define IEEE80211_RADIOTAP_MCS_HAVE_GI		0x04
>>   #define IEEE80211_RADIOTAP_MCS_HAVE_FMT		0x08
>>   #define IEEE80211_RADIOTAP_MCS_HAVE_FEC		0x10
>> +#define IEEE80211_RADIOTAP_MCS_HAVE_STBC	0x20
>
> Umm, need to do radiotap standardisation process, so NACK until then.
>
> johannes
>

Until i get response from radiotap list, is it possible to merge or 
review patches 1 and 3. They are independent from other patches.

-- 
Regards,
Oleksij

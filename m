Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53468 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaAPMnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 07:43:45 -0500
Received: from [192.168.1.221] ([93.218.75.192]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0Mh5h7-1VhPv20VBh-00MIL9 for
 <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 13:43:44 +0100
Message-ID: <52D7D3FC.9020808@rempel-privat.de> (sfid-20140116_134349_775880_5B5142E3)
Date: Thu, 16 Jan 2014 13:43:40 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@meshcoding.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH v2 1/5] ath: add common function ath_is_mybeacon
References: <1389803862-9078-1-git-send-email-linux@rempel-privat.de> <52D7CC0A.8080209@meshcoding.com>
In-Reply-To: <52D7CC0A.8080209@meshcoding.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 16.01.2014 13:09, schrieb Antonio Quartulli:
> On 15/01/14 17:37, Oleksij Rempel wrote:
>> +bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr);
>>  
> 
> another late comment: wouldn't it be better is the function was called
> is_my_beacon() instead of is_mybeacon() ?

Right now i see that this check affect almost all wifi driver.
Theoretically it can be placed to some more generic place. Where?

My actual target are these patch set:
https://github.com/olerem/linux-2.6/commits/wifi-ath-common_more

is_my_beacon() is only sight result of it.

-- 
Regards,
Oleksij

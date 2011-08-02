Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4817 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab1HBUlJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 16:41:09 -0400
Message-ID: <4E3860E3.20205@gnu.org> (sfid-20110802_224113_421058_5CE450EE)
Date: Tue, 02 Aug 2011 16:41:07 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Alex Hacker <hacker@epn.ru>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Misprint in ar9003_phy.h. Fix a misprint wich
 can cause incorrect calibration process.
References: <1312297234-24166-1-git-send-email-hacker@epn.ru> <20110802175024.GG14167@tuxdriver.com>
In-Reply-To: <20110802175024.GG14167@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2011 01:50 PM, John W. Linville wrote:
> On Tue, Aug 02, 2011 at 09:00:34PM +0600, Alex Hacker wrote:
>> ---
>>   drivers/net/wireless/ath/ath9k/ar9003_phy.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> Missing Signed-off-by...

And while at that, the subject line is misspelled, which is ironic for a 
patch fixing a typo :)

Also, the subject line should be one compact phrase that fits 80 
characters (or even shorter).  The period at the end is not needed. 
Please check the existing git log.  Something like this would be fine:

ath9k: typo fix in ar9003_phy.h that may cause incorrect calibration

-- 
Regards,
Pavel Roskin

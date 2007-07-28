Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63716 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128AbXG1Klw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2007 06:41:52 -0400
Message-ID: <46AB1D68.1020808@lwfinger.net>
Date: Sat, 28 Jul 2007 05:41:44 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jiri Benc <jbenc@suse.cz>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: pull request
References: <20070727192617.5ae82584@griffin.suse.cz> <46AA31A4.3050205@lwfinger.net>
In-Reply-To: <46AA31A4.3050205@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Jiri Benc wrote:
>> John,
>>
>> please pull from
>> git://git.kernel.org/pub/scm/linux/kernel/git/jbenc/mac80211.git up-2.6
>> to obtain patches below.
>>
>> This is intended for wireless-2.6. Because of the number of patches and
>> the fact they are not much tested, it's maybe a good idea not to push
>> them upstream immediately - but that's up to you.
> 
> Now that a patch adding SSB to mainline is available, I will move 
> bcm4301 into wireless-2.6 and do some testing of mac80211 that way.

I don't think these patches have made it to wireless-2.6 yet, but when I moved the bcm4301 code to
the wireless-2.6 tree (last commit 1e4dcd22), it failed, whereas moving it to a downloaded copy of
2.6.22.1 works. I'm looking at the mac80211 diffs to see where the problem lies.

This failure also occurs for Linus's tree, thus it is a regression from 2.6.22 to 2.6.23-rc1.

Larry


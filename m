Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56516 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbZCBWbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 17:31:49 -0500
Message-ID: <49AC5E4C.2020201@hauke-m.de> (sfid-20090302_233151_822090_2FDC1C6E)
Date: Mon, 02 Mar 2009 23:31:40 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: pat-lkml <pat-lkml@erley.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [patch] Update compat.diff
References: <49A88FF8.1040607@erley.org> <43e72e890903021322n2005bf79jda8df4497498d5a6@mail.gmail.com>
In-Reply-To: <43e72e890903021322n2005bf79jda8df4497498d5a6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this patch does not look very nice.
The part of compat.diff for net/wireless/nl80211.c was for Johannes
commit b8120417fc6ee609430c5436fe9ed07ffc2e63ba in wireless-testing.
This patch was reverted in commit
4d8bfeff50982158c4ec4ed6c38388ba3bfc9c9c. The whole patch for nl80211.c
is useless for kernel older than 2.6.30 and will case problems on this
kernel. (I know it does not exist for now ;-) ).
In my opinion it will be the best to delete the part for nl80211.c from
compat.diff for now.

Hauke

Luis R. Rodriguez wrote:
> On Fri, Feb 27, 2009 at 5:14 PM, pat-lkml <pat-lkml@erley.org> wrote:
>> This updates compat.diff for wireless-testing commit
>> 68a4ef439847ed4bc07f17d398fe06c34f15d5da
>>
>> Signed-off-by: Pat Erley<pat-lkml@erley.org>
> 
> Thanks applied, now just waiting for git pull to finish on wireless.kernel.org.
> 
>   Luis

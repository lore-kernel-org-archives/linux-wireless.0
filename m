Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58257 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab2JQMQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2012 08:16:09 -0400
Message-ID: <507EA183.10409@openwrt.org> (sfid-20121017_141613_434225_F4368E62)
Date: Wed, 17 Oct 2012 14:16:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Subject: Re: [PATCH 3.7] Revert "ath9k_hw: Updated AR9003 tx gain table for
 5GHz"
References: <1350474643-59518-1-git-send-email-nbd@openwrt.org> <CAD2nsn3ceRowmsxsssXT1TQYeWDxH9dby8=mFDJvV++dESJQYA@mail.gmail.com>
In-Reply-To: <CAD2nsn3ceRowmsxsssXT1TQYeWDxH9dby8=mFDJvV++dESJQYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-17 1:59 PM, Mohammed Shafi wrote:
> Hi Felix,
> 
> On Wed, Oct 17, 2012 at 5:20 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> This reverts commit a240dc7b3c7463bd60cf0a9b2a90f52f78aae0fd.
>>
>> This commit is reducing tx power by at least 10 db on some devices,
>> e.g. the Buffalo WZR-HP-G450H.
> 
> a minor concern, seems to be a reasonable amount of changes in the initvals.
> should be fine with the stable kernel releases, just worried about
> merge conflicts ?
This particular gain table hasn't changed in a while, I don't expect any
merge conflicts.
I've had this patch for a while, as I was waiting for a response from
the team that made the change in the first place. I never got a proper
response from that team, so I'm sending the revert now.

- Felix

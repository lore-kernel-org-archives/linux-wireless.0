Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3AOLWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 06:22:41 -0500
Message-ID: <1358248982.4648.1.camel@jlt4.sipsolutions.net> (sfid-20130115_122248_185420_7BF0235D)
Subject: Re: Tx AMSDU Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org
Date: Tue, 15 Jan 2013 12:23:02 +0100
In-Reply-To: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com> (sfid-20130115_112135_426942_4624421E)
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
	 (sfid-20130115_112135_426942_4624421E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Is there any work in progress/planned related to Tx AMSDU logic in mac80211?

At some point Felix was planning to look at this, but I don't think he
ever did. I guess he'll correct me if I'm wrong.

> Even though only Rx is mandatory, but to test the Rx we need the Tx.
> 
> I see that the support is there in mwifiex(marvell's) driver. So is
> there any patent/legal issue before we can implement one?

I'm not aware of any issue. You could probably even take some of that
code and make it some generic cfg80211 helper library for use by both
mwifiex and mac80211.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53236 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2LGJE5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 04:04:57 -0500
Message-ID: <50C1B132.5060903@openwrt.org> (sfid-20121207_100502_332981_1B04AE65)
Date: Fri, 07 Dec 2012 10:04:50 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com
Subject: Re: [PATCH] Revert "ath9k_hw: Update AR9003 high_power tx gain table"
References: <1354815611-7220-1-git-send-email-nbd@openwrt.org> <20673.22551.238357.62260@gargle.gargle.HOWL>
In-Reply-To: <20673.22551.238357.62260@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-12-07 3:44 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> This reverts commit f74b9d365ddd33a375802b064f96a5d0e99af7c0.
>> 
>> Turns out reverting commit a240dc7b3c7463bd60cf0a9b2a90f52f78aae0fd
>> "ath9k_hw: Updated AR9003 tx gain table for 5GHz" was not enough to
>> bring the tx power back to normal levels on devices like the
>> Buffalo WZR-HP-G450H, this one needs to be reverted as well.
>> 
>> This revert improves tx power by ~10 db on that device
> 
> Will this impact other devices ?
I don't know any other devices that are using this particular tx power
table.

- Felix


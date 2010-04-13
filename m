Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47161 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab0DMUJE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 16:09:04 -0400
Message-ID: <4BC4CF57.6040704@openwrt.org>
Date: Tue, 13 Apr 2010 22:08:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 000/102] ath9k: add AR9003 support
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com> <20100413195806.GD6722@tuxdriver.com>
In-Reply-To: <20100413195806.GD6722@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-13 9:58 PM, John W. Linville wrote:
> On Thu, Apr 08, 2010 at 03:25:56PM -0400, Luis R. Rodriguez wrote:
>> This series adds support for a new chipset family for the ath9k driver,
>> the AR9003 harware family. This family of chipsets will includes 2-stream
>> and 3-stream devices. We start off by supporting only 2-streams on both
>> devices. Both the 2-stream and 3-stream devices are fully functional at
>> this point. We have a few more items which we will iron out as part
>> of future patches but we're sending this out so that we don't stall
>> development on more cleanups/etc. Our delta is already quite large.
>> 
>> For information of the status of this driver you can refer to:
>> 
>> http://wireless.kernel.org/en/users/Drivers/ath9k/todo/ar93xx
>> 
>> You can download an all-in-one series of all these patches here:
>> 
>> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2010/all-04-08-v2.patch
>> 
>> sha1sum:
>> 412524e75fb512603a31211e72ff67c635d5d04d  all-04-08-v2.patch
> 
> I started trying to apply these, but I got a lot of rejects and even
> hit a file that didn't exist.  I hesitate to ask, but can we expect
> a repost? :-)
There will be a repost very soon. We're still fixing up some stuff and
adding some cleanups...

- Felix

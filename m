Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31078 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbaKNPJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 10:09:46 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Pushpal Sidhu <psidhu@gateworks.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] ath10k: testmode support
References: <20140910152136.12610.18499.stgit@potku.adurom.net>
	<87zje528im.fsf@kamboji.qca.qualcomm.com>
	<CAD1M061Gky-a28Rokmgyd-5x_m_h1SNmj9ZxUd4v1fP=bae35g@mail.gmail.com>
Date: Fri, 14 Nov 2014 17:09:21 +0200
In-Reply-To: <CAD1M061Gky-a28Rokmgyd-5x_m_h1SNmj9ZxUd4v1fP=bae35g@mail.gmail.com>
	(Pushpal Sidhu's message of "Thu, 13 Nov 2014 16:08:30 -0800")
Message-ID: <87389lstst.fsf@kamboji.qca.qualcomm.com> (sfid-20141114_160950_610820_F109B19F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pushpal Sidhu <psidhu@gateworks.com> writes:

> On Thu, Sep 11, 2014 at 1:43 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>
>>> latest version of my testmode patches. Getting closer, more or less cosmetic
>>> changes this time :)
>
> While looking through this patchset (sorry it took two months), I have
> to wonder: what's this utf.bin blob? It seems in order to use
> testmode, we need this binary blob that I can't seem to find (I looked
> in linux-firmware and https://github.com/kvalo/ath10k-firmware). If,
> for whatever reason, this binary blob is not releasable, what's the
> point of adding in testmode to this driver?

testmode is for functionality needed in the factory, it's not meant for
normal users. That's why all distros should have CONFIG_NL80211_TESTMODE
disabled.

-- 
Kalle Valo

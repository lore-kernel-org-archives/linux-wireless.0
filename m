Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56607 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbHDRC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 13:02:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: mbizon@freebox.fr
Cc: David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
	<1436455659.36587.131.camel@sakura.staff.proxad.net>
Date: Tue, 04 Aug 2015 20:02:23 +0300
In-Reply-To: <1436455659.36587.131.camel@sakura.staff.proxad.net> (Maxime
	Bizon's message of "Thu, 09 Jul 2015 17:27:39 +0200")
Message-ID: <87vbcvyokg.fsf@kamboji.qca.qualcomm.com> (sfid-20150804_190234_092136_D6298EC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxime Bizon <mbizon@freebox.fr> writes:

> On Fri, 2015-07-03 at 06:10 +0000, David Lin wrote:
>
> Hello,
>
>> The Linux driver for WRT1900AC. The work was initially developed as
>> part of openwrt effort and maintained on
>> https://github.com/kaloz/mwlwifi.
>
> I see *massive* code duplication with the mwl8k driver.

I haven't looked at the driver myself yet. Do you have any estimates how
much duplication there is?

> This is, I guess, not a surprise since the supported chipset are an
> evolution of the ones supported by mwl8k, just look at how close/similar
> the descriptor format is.
>
> The problem is that each new Marvell chipset comes with a new firmware
> version, and there is no effort to have a common firmware API or code
> base that supports multiple chipsets.
>
> That pushes the bloat on the kernel side, do we really agree on that ?

That is a very good question. The kernel should not be a dumping ground
for random drivers which duplicate lots of code but this is a sort of
gray area and depends on the case.

Did Marvell reply to this? I didn't find any comments about this.

-- 
Kalle Valo

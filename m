Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38487 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952Ab1GDJ4i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 05:56:38 -0400
Message-ID: <4E118E3F.7000408@openwrt.org> (sfid-20110704_115641_104276_E951E728)
Date: Mon, 04 Jul 2011 16:56:15 +0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/8] ath5k: add missing checks for rfgain probe
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org> <CAFtRNNzEUZ7LfgQ=XQjrjtj382puuaJhx=mHnFJhjt0Act6o_Q@mail.gmail.com>
In-Reply-To: <CAFtRNNzEUZ7LfgQ=XQjrjtj382puuaJhx=mHnFJhjt0Act6o_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-07-04 4:48 PM, Nick Kossifidis wrote:
> 2011/7/4 Felix Fietkau<nbd@openwrt.org>:
>>  rfgain probe is only necessary for OFDM operation on AR5112 and no other
>>  radio chips
>>
>
> It's also available on RF5111 (with AR5211 or AR5212)...
Oh, right, missed that. Will send a v2.

- Felix

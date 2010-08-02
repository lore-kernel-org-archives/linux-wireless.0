Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43051 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0HBLSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 07:18:07 -0400
Message-ID: <4C56A969.6060406@openwrt.org>
Date: Mon, 02 Aug 2010 13:18:01 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org> 	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com> 	<201008021313.54850.br1@einfach.org> <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com> 	<4C5688F7.1070200@openwrt.org> <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com> 	<4C568D23.2000203@openwrt.org> <AANLkTinGdwt4bSPRDV=ZfPBmoKS42GgUVjLAg_O1vL3i@mail.gmail.com> 	<4C5690C7.2080104@openwrt.org> <AANLkTimoU+iF2bVJ-Fs4iT3k5v0iU9PaE783NhUdnQQ-@mail.gmail.com> 	<4C5699AE.6090103@openwrt.org> <AANLkTimWnefNaiPzqMXwc6d8aePmy3SZ8w9FB4=6CRko@mail.gmail.com> 	<4C56A251.7080903@openwrt.org> <AANLkTimWpvOQrdgP=1+4zm2=feN51G_+_LAnPgaQqUuF@mail.gmail.com>
In-Reply-To: <AANLkTimWpvOQrdgP=1+4zm2=feN51G_+_LAnPgaQqUuF@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-08-02 12:51 PM, Luis R. Rodriguez wrote:
> On Mon, Aug 2, 2010 at 3:47 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> 802.11n hardware => need to bring down the interface before changing
>>                    the antenna settings
> 
> The current patch does not deal with the 802.11n case you mentioned.
And why should it? The series does not add antenna control support to
any specific 802.11n driver.

- Felix

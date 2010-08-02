Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35345 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab0HBRqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 13:46:21 -0400
Received: by ywh1 with SMTP id 1so1320232ywh.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 10:46:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C56A969.6060406@openwrt.org>
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org>
	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
	<201008021313.54850.br1@einfach.org> <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com>
	<4C5688F7.1070200@openwrt.org> <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com>
	<4C568D23.2000203@openwrt.org> <AANLkTinGdwt4bSPRDV=ZfPBmoKS42GgUVjLAg_O1vL3i@mail.gmail.com>
	<4C5690C7.2080104@openwrt.org> <AANLkTimoU+iF2bVJ-Fs4iT3k5v0iU9PaE783NhUdnQQ-@mail.gmail.com>
	<4C5699AE.6090103@openwrt.org> <AANLkTimWnefNaiPzqMXwc6d8aePmy3SZ8w9FB4=6CRko@mail.gmail.com>
	<4C56A251.7080903@openwrt.org> <AANLkTimWpvOQrdgP=1+4zm2=feN51G_+_LAnPgaQqUuF@mail.gmail.com>
	<4C56A969.6060406@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Aug 2010 10:45:59 -0700
Message-ID: <AANLkTimcaUSdr_hAECfr2ZFQOdXYmZ-vkkDiMze3kQL6@mail.gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 2, 2010 at 4:18 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-08-02 12:51 PM, Luis R. Rodriguez wrote:
>> On Mon, Aug 2, 2010 at 3:47 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> 802.11n hardware => need to bring down the interface before changing
>>>                    the antenna settings
>>
>> The current patch does not deal with the 802.11n case you mentioned.
> And why should it? The series does not add antenna control support to
> any specific 802.11n driver.

Because it documents support for 802.11n. You should not expect
someone writing their ops for an 802.11n driver to fill in the 802.11n
gaps for you unless you mark your API as being only for legacy.

  Luis

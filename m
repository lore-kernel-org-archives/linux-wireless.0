Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0HBFby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 01:31:54 -0400
Received: by iwn7 with SMTP id 7so3805036iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 22:31:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008021259.16623.br1@einfach.org>
References: <20100727094732.27186.30900.stgit@tt-desk> <201007291111.27417.br1@einfach.org>
	<AANLkTinH-2VNYGGBVha-M2HOzYJYe_GBb3Ww1V6i6Hyc@mail.gmail.com>
	<201008021259.16623.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 1 Aug 2010 22:31:32 -0700
Message-ID: <AANLkTin0_APCmVQiCa19NU4zJsBdbXwAgpX23fo9r+vD@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 1, 2010 at 8:59 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Fri July 30 2010 00:09:17 you wrote:
>> On Wed, Jul 28, 2010 at 7:11 PM, Bruno Randolf <br1@einfach.org> wrote:
>> > i already tried to explain several times why FIXED_A, FIXED_B, or
>> > DIVERSITY is not enough even for "legacy". please re-read the mails and
>> > the description of the first patch - i really don't want to re-iterate
>> > it *again*. thanks :)
>>
>> What legacy device and respective device driver do we support upstream
>> on the kernel that has this sort of extra antenna setup? Do you
>> foresee this happening?
>
> right now, probably none. but it's easy to this to ath5k. madwifi supported it
> and it's just a matter of setting tx and rx antennas (it's already there as
> AR5K_ANTMODE_DEBUG). i might add it, just to make my case... ;)
>
> anyhow, i can see your point of view now. but while you might not care about
> anything before 802.11n - there are millions of what you call 'legacy' chips
> out there (and you guys are actually still selling them!), so i think it's
> worth it to properly support them, especially since i still believe that my
> proposal is usable for both 802.11n and before.

I am not saying to drop legacy support I am saying to just support
legacy via the two standard antenna model because there is nothing
visible being supported which I think merits expanding a simple API
for legacy.

 Luis

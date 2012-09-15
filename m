Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50984 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2IOB0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 21:26:37 -0400
MIME-Version: 1.0
In-Reply-To: <20563.54449.930282.825384@gargle.gargle.HOWL>
References: <1347637262-27782-1-git-send-email-bkamatch@qca.qualcomm.com>
 <CAB=NE6WBLusFkQP-a9mCxM2Hu-NyWvUiF8iALY6YvvbV81eKNg@mail.gmail.com>
 <CAB=NE6XYjYrRSA8Xupu21GWoCd-jv63ic32Q3rP7YiVHajTWTg@mail.gmail.com>
 <CAB=NE6UG647WMS7kW=xEFgU=PGMq7fdt7G0k_8sMqkkS9sZkcw@mail.gmail.com> <20563.54449.930282.825384@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 14 Sep 2012 18:26:15 -0700
Message-ID: <CAB=NE6XXN5ZqZ3_ho8MermvXMSU67MWv5j26B7_1j+BEySMnSA@mail.gmail.com> (sfid-20120915_032711_402036_393FBE4E)
Subject: Re: [PATCH 1/4] compat-drivers: update pending-stable patches.
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, backports@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 14, 2012 at 6:06 PM, Sujith Manoharan <c_manoha@qualcomm.com> wrote:
> Luis R. Rodriguez wrote:
>> So based on what I think you described you only want these two hunks
>> from that patch... to avoid regressions possibly caused by Felix'
>> other changes.
>
> This will not cause any regression for AR9462 because the patch does this:
>
>        if (!AR_SREV_9300(ah))
>                return;
>
> I think all this confusion would have been avoided if the 3.5.y patches had
> just backported Felix's patch. :)

Oh well, I just relabeled the patch / description, put into
linux-next-pending for now and kicked out a new set of releases that
includes your other patch as well.

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5.3-1-snpc.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5.3-2-sn.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5.3-2-snpc.tar.bz2

ckmake tests will follow up.

  Luis

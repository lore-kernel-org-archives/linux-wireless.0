Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64038 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0G2PJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 11:09:38 -0400
Received: by iwn7 with SMTP id 7so399869iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 08:09:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201007291111.27417.br1@einfach.org>
References: <20100727094732.27186.30900.stgit@tt-desk> <201007281106.06813.br1@einfach.org>
	<AANLkTimBu2=9XhzKwUi1ZpRmGWA+C4GCDgXqp-YJVLxt@mail.gmail.com>
	<201007291111.27417.br1@einfach.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 29 Jul 2010 08:09:17 -0700
Message-ID: <AANLkTinH-2VNYGGBVha-M2HOzYJYe_GBb3Ww1V6i6Hyc@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 7:11 PM, Bruno Randolf <br1@einfach.org> wrote:
> i already tried to explain several times why FIXED_A, FIXED_B, or DIVERSITY is
> not enough even for "legacy". please re-read the mails and the description of
> the first patch - i really don't want to re-iterate it *again*. thanks :)

What legacy device and respective device driver do we support upstream
on the kernel that has this sort of extra antenna setup? Do you
foresee this happening? New silicon simply won't be using legacy
(non-802.11) so I do not expect new chipsets to have this setup and I
do not foresee neither a driver supporting these devices nor interest
from anyone actually implementing this upstream.

Even consider Turbo stuff on Atheros legacy chipsets. For eons I've
been recommending this crap just be removed from ath5k but yet there
has been resistance. To this day no one has worked on it nor do I
expect anyone will and actually get Turbo support upstream.

So yes, perhaps some odd ball legacy devices exist with a setup other
than ANT_A ANT_B and DIVERSITY but I do not think we will support them
upstream, ever.

  Luis

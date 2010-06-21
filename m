Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:64808 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab0FUSnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:43:14 -0400
Received: by pxi12 with SMTP id 12so1497071pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jun 2010 11:43:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006211059.58879.helmut.schaa@googlemail.com>
References: <201006211059.58879.helmut.schaa@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 11:37:53 -0700
Message-ID: <AANLkTinj36oA6QpEiYywGGkRqCmNRHSeR643HpiUsXC-@mail.gmail.com>
Subject: Re: [PATCH] mac80211: allow selection of minstrel_ht as default rc
	algo
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 21, 2010 at 1:59 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Allow selection of minstrel_ht as default rate control algorithm. At the
> moment minstrel_ht can only be requested by the driver code but not selected
> as default in make menuconfig.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Shouldn't this just be enabled when you enable minstrel? I don't get
why we would split up the two.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53744 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab2EVLd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 07:33:27 -0400
Received: by gglu4 with SMTP id u4so5235060ggl.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2012 04:33:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120517230400.GB22418@yumi.tdiedrich.de>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
Date: Tue, 22 May 2012 13:33:27 +0200
Message-ID: <CAGXE3d-MTZu16cU1wybd6zehGOudKPadknuHm9MG6JDVRKmDag@mail.gmail.com> (sfid-20120522_133331_244839_B2A0531E)
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
<ranma+openwrt@tdiedrich.de> wrote:
> rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
> respectively, similar to how it is already done in rt2[45]00pci.c
>
> rt2800lib.c doesn't initialize max_power and thus after
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
> was applied txpower is limited to 0 for these devices.
>
> This should be the proper fix compared to the net/wireless/reg.c
> hack in http://patchwork.openwrt.org/patch/2165/

Btw. Tobias, did this affect the real tx power of the device at all or
is this just
a cosmetic issue?

Thanks,
Helmut

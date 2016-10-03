Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbcJCMVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 08:21:34 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Franc\[e\]sco" <lolisamurai@waifu.club>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8192EU on rtl8xxxu driver breaks every few minutes
References: <c6784dde-65df-87cd-f97e-33fbd8dd55ff@waifu.club>
        <wrfj4m5acouw.fsf@redhat.com>
        <80b8ae50-ca27-674f-0e7e-79b931bae199@waifu.club>
        <wrfjr3816jpr.fsf@redhat.com>
        <ec3a2db3-1e52-e2f1-1a3a-52bdfed3c803@waifu.club>
Date: Mon, 03 Oct 2016 08:21:32 -0400
In-Reply-To: <ec3a2db3-1e52-e2f1-1a3a-52bdfed3c803@waifu.club> (Franc[e]sco's
        message of "Sun, 2 Oct 2016 18:03:16 +0200")
Message-ID: <wrfjvax939o3.fsf@redhat.com> (sfid-20161003_142138_835288_BAFA0CBD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Franc[e]sco" <lolisamurai@waifu.club> writes:
> Thanks for the patch, just tested the rtl8xxxu-devel branch and it seems
> to have the same exact issue with the same dmesg output with the
> addition of "rtl8192eu_active_to_emu: Disabling MAC timed out" when I
> disconnect the dongle.
>
> I checked out and compiled the whole kernel from the branch because the
> 4.7.4 sources seemed to be missing the rtl8192eu_active_to_emu function.

There are other patches related to the 8192eu in the wireless tree which
fix some issues with the dongle if you reload the driver. Alternatively
pull my git tree and build that.

Jes

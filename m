Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47455 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759755Ab0JHWHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 18:07:21 -0400
Received: by qyk1 with SMTP id 1so525645qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 15:07:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 9 Oct 2010 00:07:20 +0200
Message-ID: <AANLkTik45KLdLf5UpjPtXTNgy4Df_BupyQ3SzRr6gZgC@mail.gmail.com>
Subject: Request for free-distributable Broadcom's (G|LP)-PHY firmware
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Broadcom fellows!

It's great that afters long years of... well, pretty horrible
relations with Linux/opensource you have taken actions to change your
image. I guess brcm80211 it's perfect yet, and people may like it more
or less, but it's no doubt you made step in the right direction.
Thanks for that!

As you should know, you released driver and firmware for 802.11n
devices only. I believe it was right, as these device seem to be the
most nowadays and were the only ones without any open source support.
For older devices: G-PHY and LP-PHY we have working b43 driver that is
in relatively good shape. However... there is one thing we still miss
for olders cards.

Every time someone wants to use b43 it's necessary to download quite
big package from openwrt, unpack it, extract firmware and install it.
That simply happens because we don't have just-firmware files with
nice licensing. And of course there goes my request:

*Can you submit G-PHY and LP-PHY firmware to linux-firmware using some
normal licensing, please?*

This is of course not the best I could wish for, but is important
anyway and it should be easy decision. Ideally you could release
sources of firmware (plus toolchain eventualy... however, we have nice
toolchain from Michael), but I guess it would need more time and
decisions to make it happen. So as for now I guess we would be happy
with just closed source but easy-distributable firmware. Could you
release, submit it?

-- 
Rafał

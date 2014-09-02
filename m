Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:46256 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaIBNnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 09:43:16 -0400
Received: by mail-la0-f53.google.com with SMTP id s18so7710251lam.40
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 06:43:15 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Sep 2014 16:43:14 +0300
Message-ID: <CANUX_P1udm36NoF-dbOARa671VthuYfrEEz2ODSmkCgDzcRe8g@mail.gmail.com> (sfid-20140902_154338_518122_F3CBE3CA)
Subject: [ANN] new experimental firmware for 7260 / 3160 / 7265 - Core7
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We made a new firmware available. This is a new code base, new
features (I haven't checked the log) and bug fixes.
It is experimental because it is still under validation cycle and
fixes are introduced on a daily basis.
I just thought that a few people would want to get their hands on an
early version of it.

The firmware is here:
https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/log/?h=Core7

Note that the filename is now iwlwifi-XXXX-10.ucode. You'll need
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=d88c8958dc13b4e4eb7fc57e3f06dc1c4abc7b1f
to actually load this firmware.

Feedback will be appreciated.

Thanks and enjoy!

Emmanuel Grumbach
egrumbach@gmail.com

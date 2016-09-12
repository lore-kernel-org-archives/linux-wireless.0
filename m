Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zoot.epublica.de ([78.46.103.157]:58487 "EHLO zoot.epublica.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755210AbcILJaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:30:10 -0400
To: linux-wireless@vger.kernel.org, Jes.Sorensen@redhat.com
Cc: Larry.Finger@lwfinger.net, Bastien Nocera <hadess@hadess.net>,
        anthony.wong@canonical.com
From: Hanno Zulla <abos@hanno.de>
Subject: Support of rtl8723bs
Message-ID: <688574b6-1141-f408-d397-535f1f69999e@hanno.de> (sfid-20160912_113014_315632_FA5EDCD5)
Date: Mon, 12 Sep 2016 11:20:54 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,
hello linux-wireless,

I'd like to know more about the current progress of rtl8723bs support
for Linux.

Googling and reading the mailing list archives found an older vendor driver
https://github.com/hadess/rtl8723bs

plus patches at
https://github.com/lwfinger/rtl8723bs

which both aren't ready for Linux according to
https://github.com/hadess/rtl8723bs/issues/96

According to
https://github.com/hadess/rtl8723bs/issues/98

there is a newer vendor driver from Realtek at
https://github.com/anthonywong/rtl8723bs
which Anthony wants to get ready for inclusion to the Ubuntu kernel.

But after reading
https://marc.info/?l=linux-wireless&m=146902477024130&w=2
it appears that even that newer vendor driver isn't ready for Jes's work.

Anyway, as an owner of such a device, I'd like to help somehow, and be
it as a guinea pig to test on my hardware. The newer vendor driver
crashed on Ubuntu' 4.4 sources and doesn't compile yet on Ubuntu 4.8-rc
sources.
https://github.com/anthonywong/rtl8723bs/issues/1

Kind regards,

Hanno

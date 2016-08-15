Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37322 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbcHOVmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 17:42:32 -0400
Received: by mail-wm0-f45.google.com with SMTP id i5so128714834wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2016 14:42:31 -0700 (PDT)
MIME-Version: 1.0
From: Mike Mu <mikemu@google.com>
Date: Mon, 15 Aug 2016 17:41:49 -0400
Message-ID: <CAGTDyhHOxwTiXtsWuy1cLq+eraikTs9McS0kUBXS2W6B09CwgQ@mail.gmail.com> (sfid-20160815_234235_904800_E4CCBFB8)
Subject: Configuring Minstrel-Blues
To: linux-wireless@vger.kernel.org
Cc: Stanley Mui <stanleymui@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linux-Wireless,

I am trying to enable Minstrel-Blues for the ath9k chipset that's used
in Google Fiber's access points. I applied the patches in
https://github.com/thuehn/Minstrel-Blues/tree/master/src onto our
backports-20160122 tree, with some unsuspicious merge conflicts, and
built an image.

To test, I ran iperf from the AP to a station very close by. I
captured the packets to look at the RSSI with and without the
Minstrel-Blues patches applied, but did not see any difference in
RSSI.

Is there anything I need to configure first to make it work? Is it
possible that I'm missing a patch that's not in backports-20160122?

Thanks!
Mike

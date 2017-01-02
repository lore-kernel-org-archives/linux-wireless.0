Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33172 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdABEdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jan 2017 23:33:08 -0500
Received: by mail-oi0-f51.google.com with SMTP id 128so277498907oig.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jan 2017 20:33:07 -0800 (PST)
MIME-Version: 1.0
From: Daniel Palmer <daniel@0x0f.com>
Date: Mon, 2 Jan 2017 13:33:06 +0900
Message-ID: <CAFr9PXmUJoQRSvvKnCANArt_oneviAyKOcR4oUpqmvBOefqgCA@mail.gmail.com> (sfid-20170102_053355_707381_6EEE5B70)
Subject: cw1200: Looking to add support for a new chip.
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

While hacking away[1] on the vendor sources for the Allwinner XR819
WiFi chip found on the OrangePi Zero board[2] I've worked out that the
driver is basically the existing cw1200 driver that is in the kernel
with support for the two stage firmware loading (alluded to for the
probably unreleased CW1X60 chips but not implemented in the kernel
driver) and some hacks for WiFi compliance tests and P2P support.

Does anyone use the cw1200 driver that could test that any changes
needed to make the XR819 work don't break it?

Please CC me as I'm not subscribed.

Cheers,

Daniel

[1] https://github.com/fifteenhex/xradio/tree/original
[2] http://linux-sunxi.org/Xunlong_Orange_Pi_Zero

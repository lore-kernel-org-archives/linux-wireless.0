Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:35606 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdLGFBY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 00:01:24 -0500
Received: by mail-yw0-f170.google.com with SMTP id m81so2501183ywd.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Dec 2017 21:01:24 -0800 (PST)
MIME-Version: 1.0
From: Farhan Khan <khanzf@gmail.com>
Date: Thu, 7 Dec 2017 00:01:02 -0500
Message-ID: <CAFd4kYCqPpL7HsOqkLsTVy8WGsiC7Dj0JnY1mNbKE3MZjcDBzQ@mail.gmail.com> (sfid-20171207_060128_922533_9C418564)
Subject: Where does rtlwifi/rtl8188ee identifies interrupt type?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am reading through the rtlwifi code, specifically rtl8188ee code. I
am trying to find the driver handles interrupts, reads from the card
and identifies what type of interrupt it receives.

I believe it will utilize the REG_HISR and REG_HIMR registers, but
only see writes to those register values, not reads which I was
expecting.

Any ideas? Thanks!

--
Farhan Khan
PGP Fingerprint: B28D 2726 E2BC A97E 3854 5ABE 9A9F 00BC D525 16EE

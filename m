Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:35095 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdCEDPq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 22:15:46 -0500
Received: by mail-pg0-f48.google.com with SMTP id b129so55700365pgc.2
        for <linux-wireless@vger.kernel.org>; Sat, 04 Mar 2017 19:15:45 -0800 (PST)
Message-ID: <1488683738.26544.4.camel@deako.com> (sfid-20170305_041604_852016_020CF2AB)
Subject: brcm: firmware for BCM43341 out of date
From: Brennan Ashton <brn@deako.com>
To: linux-firmware@kernel.org
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org
Date: Sat, 04 Mar 2017 19:15:38 -0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware in the current tree for the BCM43341 hardware seems to
result in some issues with the 5GHz band.  phy info would show the
band, but scanning would not return any 5GHz networks. The current
version in the tree is 6.10.190.49  A newer version (6.10.190.55) was
released that has been bundled with the android platform. This version
seemed to resolve the issues that I was having.

I was not quite sure what the process was for this since I assume that
the patch needs to be at least signed off by someone from Broadcom.

--Brennan

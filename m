Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:51281 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751407AbdIQQFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 12:05:49 -0400
Received: by mail-wr0-f175.google.com with SMTP id z39so4586566wrb.8
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 09:05:48 -0700 (PDT)
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Charles Chambers <cchamb2@gmail.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Wifi driver for RTL8191SU
Message-ID: <3aaaf30c-c62a-8cf6-b2dd-76cdeb5dfbec@gmail.com> (sfid-20170917_180553_160252_52B4DA96)
Date: Sun, 17 Sep 2017 18:05:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Charles Chambers wrote:

> I have a USB wifi adapter based on the subject chipset.  Debian Linux
> for its new release (9.x) incorporates version 4.9 of the kernel, which
> does not work with the existing driver for this USB wifi adapter.  The
> driver for it (under Debian 8.x) shows as "r8712U".  There's a movement
> afoot to update the driver.
> 
> Any idea when an updated driver (or a wide beta restoring *some*
> functionality) could be expected?


There are three drivers:

- r8712u from staging, crappy with no future in staging or drivers/net/wireless
- r92su or rtl8192su from https://github.com/chunkeey/rtl8192su


More info about Realtek at: https://wireless.wiki.kernel.org/en/users/Drivers/rtl819x

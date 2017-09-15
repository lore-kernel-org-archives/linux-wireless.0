Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:55305 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750767AbdIOFI1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 01:08:27 -0400
Received: by mail-qk0-f171.google.com with SMTP id u73so1184373qkl.12
        for <linux-wireless@vger.kernel.org>; Thu, 14 Sep 2017 22:08:26 -0700 (PDT)
Received: from pc.farhan.codes ([2001:470:8:209:f0d8:e961:750c:4e5e])
        by smtp.gmail.com with ESMTPSA id a13sm43222qkj.35.2017.09.14.22.08.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Sep 2017 22:08:25 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Farhan Khan <khanzf@gmail.com>
Subject: rtlwifi/rtl8188ee baseband config explanation request
Message-ID: <f37044ee-d0fb-1a3a-d98b-3233434f68ea@gmail.com> (sfid-20170915_070830_756725_2E3AD6A7)
Date: Fri, 15 Sep 2017 01:08:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am trying to get a high-level understanding of what occurs in
rtl88e_phy_bb_config() in
drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c. I understand the
code up until it runs _rtl88e_phy_bb8188e_config_parafile() .

>From there, I see that phy_config_bb_with_headerfile() will write the
values in RTL8188EEPHY_REG_1TARRAY, runs phy_config_bb_with_pghdr(),
then write the values in RTL8188EEAGCTAB_1TARRAY.

Please provide a high-level explanation of
phy_config_bb_with_headerfile(), and more particularly, of
phy_config_bb_pghdr(). What are their objectives? Also, is there a
reason for this specific order or can it be in any otherwise?

Thanks!

--
Farhan Khan
PGP Fingerprint: B28D 2726 E2BC A97E 3854 5ABE 9A9F 00BC D525 16EE

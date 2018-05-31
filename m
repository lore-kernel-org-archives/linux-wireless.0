Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59696 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755036AbeEaPJz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 11:09:55 -0400
Received: from mail-io0-f199.google.com ([209.85.223.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fOPD8-0003bX-6n
        for linux-wireless@vger.kernel.org; Thu, 31 May 2018 15:09:54 +0000
Received: by mail-io0-f199.google.com with SMTP id k21-v6so18455580ioj.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2018 08:09:54 -0700 (PDT)
Date: Thu, 31 May 2018 10:09:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [ANN] wireless-regdb: master-2018-05-31
Message-ID: <20180531150950.GI3401@ubuntu-xps13> (sfid-20180531_171017_264336_F1096CDF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new release of wireless-regdb (master-2018-05-31) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2018.05.31.tar.gz

The short log of changes since the 2018-05-09 release is below.

Thanks,
Seth

---

Seth Forshee (6):
      wireless-regdb: Add 5725-5875 MHz rule for France (FR)
      wireless-regdb: Update rules for Panama (PA) and add 60 GHz rule
      wireless-regdb: Fix comparison of WmmRule with NoneType in python 3
      wireless-regdb: Fix iteration in create_wmms() for python 3
      wireless-regdb: Fix power limit in 5725-5785 GHz rule for France
      wireless-regdb: update regulatory database based on preceding changes

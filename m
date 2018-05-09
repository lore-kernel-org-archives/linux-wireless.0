Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57406 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932701AbeEIOU0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 10:20:26 -0400
Received: from mail-it0-f70.google.com ([209.85.214.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fGPxB-0003vn-HA
        for linux-wireless@vger.kernel.org; Wed, 09 May 2018 14:20:25 +0000
Received: by mail-it0-f70.google.com with SMTP id p11-v6so11017088itb.8
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 07:20:25 -0700 (PDT)
Date: Wed, 9 May 2018 09:20:22 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [ANN] wireless-regdb: master-2018-05-09
Message-ID: <20180509142022.GB3375@ubuntu-xps13> (sfid-20180509_162030_098460_E87EAF84)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new release of wireless-regdb (master-2018-05-09) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2018.05.09.tar.gz

The short log of changes since the 2017-12-23 release is below.

Thanks,
Seth

---

Haim Dreyfuss (2):
      wireless-regdb: Add wmm rule for EEA and EFTA countries
      wireless-regdb: Parse wmm rule data

Matthias Schiffer (2):
      wireless-regdb: do not rely on sorting of dict keys in conversion scripts
      wireless-regdb: make scripts compatible with Python 3

Seth Forshee (2):
      wireless-regdb: Update rules for QA and add 5 GHz and 60 GHz rules
      wireless-regdb: update regulatory database based on preceding changes

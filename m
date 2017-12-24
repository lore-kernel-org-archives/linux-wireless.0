Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32979 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdLXDyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Dec 2017 22:54:36 -0500
Received: from mail-io0-f198.google.com ([209.85.223.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSxMx-0004sp-Bq
        for linux-wireless@vger.kernel.org; Sun, 24 Dec 2017 03:54:35 +0000
Received: by mail-io0-f198.google.com with SMTP id c196so23771313ioc.3
        for <linux-wireless@vger.kernel.org>; Sat, 23 Dec 2017 19:54:35 -0800 (PST)
Date: Sat, 23 Dec 2017 21:54:31 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [ANN] wireless-regdb: master-2017-12-23
Message-ID: <20171224035431.GA5626@ubuntu-xps13> (sfid-20171224_045440_355323_D6893655)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new release of wireless-regdb (master-2017-12-23) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2017.12.23.tar.gz

Note that this is the first release to include the new regulatory
database format, supporting direct loading of the database by the
kernel. The short log of changes since the 2017-03-07 release is below.

Thanks,
Seth

---

Andreas Mohr (1):
      wireless-regdb: reduce power level limit of KR (Korea) 802.11b/g/n to the certification-requested "20mW" (13dBm).

Aron Rosenberg (1):
      Set NO-OUTDOOR Flag on Canada 5Ghz 5150 to 5250

Chen-Yu Tsai (2):
      wireless-regdb: Update regulatory document references for Taiwan (TW)
      wireless-regdb: Add 60 GHz rule for Taiwan (TW)

Edwin Steele (1):
      wireless-regdb: Update rules for Turkey 5ghz

Johannes Berg (1):
      regdb: write firmware file format (version code 20)

Seth Forshee (8):
      wireless-regdb: Add 5 Ghz rules for Kazakhstan (KZ)
      wireless-regdb: Update rules for Denmark (DK)
      wireless-regdb: Restore generation of old format database files
      wireless-regdb: Add sforshee's x509 certificate
      wireless-regdb: Better support for generating public certificates
      wireless-regdb: Install regulatory.db and regulatory.db.p7s to /lib/firmware
      wireless-regdb: Document regulatory.db in the manual page
      wireless-regdb: update regulatory database based on preceding changes

Sven Eckelmann (1):
      wireless-regdb: Update regulatory rules for Singapore (SG)

Xose Vazquez Perez (1):
      wireless-regdb: add Short Range Devices (SRD) (ETSI EN 300 440) for Spain

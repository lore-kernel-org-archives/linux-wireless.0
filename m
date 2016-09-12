Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36843 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbcILFWV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 01:22:21 -0400
Received: by mail-oi0-f53.google.com with SMTP id q188so174153261oia.3
        for <linux-wireless@vger.kernel.org>; Sun, 11 Sep 2016 22:22:21 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 12 Sep 2016 07:22:20 +0200
Message-ID: <CACna6ryBmEX1OVijdapGiTXs9dYssy+gzMnY2Sr_rd+OpMO1-g@mail.gmail.com> (sfid-20160912_072225_509876_0D48FE6C)
Subject: Request for brcmfmac4366c-pcie.bin
To: Hante Meuleman <hante.meuleman@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Nathan Grennan <kernel-bugzilla@cygnusx-1.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Few months ago Hante added support for 4366c0 to the brcmfmac. There
are already few devices with this chipset on the market. We even have
some related bug report at kernel:
https://bugzilla.kernel.org/show_bug.cgi?id=3D135321

Unfortunately the firmware for this chipset is still missing. Can you
build it and submit to linux-firmware.git, please?

--=20
Rafa=C5=82

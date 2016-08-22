Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:36056 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbcHVOHr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 10:07:47 -0400
MIME-Version: 1.0
From: David Binderman <linuxdev.baldrick@gmail.com>
Date: Mon, 22 Aug 2016 15:07:44 +0100
Message-ID: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com> (sfid-20160822_160803_241193_51644DE9)
Subject: linux-4.8-rc3/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:3533:
 pointless test ?
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dcb314@hotmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

linux-4.8-rc3/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:3533]:
(style) Condition 'pBtMgnt.ExtConfig.HCIExtensionVer>=1' is always
true

Source code is

        if (pBtMgnt->ExtConfig.HCIExtensionVer < 1) {
        ....
        } else if (pBtMgnt->ExtConfig.HCIExtensionVer >= 1) {

Suggest remove second test.


Regards

David Binderman

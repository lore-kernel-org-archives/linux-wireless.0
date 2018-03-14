Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35038 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932634AbeCNBWJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 21:22:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+DvKQK9jRe5YOk_K4DzBYkh2VUys56XbaYZRGs0fn2WJNT+nQ@mail.gmail.com>
References: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com>
 <5AA464DE.90100@broadcom.com> <CA+DvKQ+hbMoWJdOuQB5n+eVF4ePf=kVuRiMbdtTUZ8ars4Pz4A@mail.gmail.com>
 <423b529d48c54eba9f7ed51922814d46@AcuMS.aculab.com> <CA+DvKQK9jRe5YOk_K4DzBYkh2VUys56XbaYZRGs0fn2WJNT+nQ@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 13 Mar 2018 21:22:08 -0400
Message-ID: <CA+DvKQJYMYCVgxZPxqCnkZn2u-sunSUF6ZTTDJ0sauhX-1qEzw@mail.gmail.com> (sfid-20180314_022228_216480_ED49D2E8)
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9: dfs: remove VLA usage
To: David Laight <David.Laight@aculab.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andreas Christoforou <andreaschristofo@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I don't think the difference between C and C++ const pointer
> conversions

I mean I don't think the difference between them was intended.

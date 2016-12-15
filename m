Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:36487 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757168AbcLOBON (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 20:14:13 -0500
Received: by mail-wj0-f195.google.com with SMTP id j10so7436372wjb.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2016 17:14:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <915ae2d7b20d455d86a574c562dfd5fe@SC-EXCH04.marvell.com>
References: <20161110175915.GB1585@katana> <507fff29bd2048c2b2295beb451943b5@SC-EXCH04.marvell.com>
 <20161113141348.GA32086@katana> <915ae2d7b20d455d86a574c562dfd5fe@SC-EXCH04.marvell.com>
From: Federico Pietro Briata <federico@briata.org>
Date: Thu, 15 Dec 2016 02:14:11 +0100
Message-ID: <CA+KKcbkTkeugMbN8=2nLW+p6YHnJKcmKQ5qzKuEFge+92bUAkw@mail.gmail.com> (sfid-20161215_021419_106866_782A1222)
Subject: Re: Problems getting mwifiex with sd8887 to work
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I'm also using sd8887 and I'm trying to make it work in adhoc mode and
encrypt the channel with wpa-none, but I got some trouble.

If I make the same specific test with from the driver from marvel
intranet, is working (maybe because the firmware is more recent ?) but
anyway the general stability with the driver is poor, I get frequent
kernel crash, I see at [1] that this driver is based on android and
I've personally to admit that mwifiex driver solved the stability side
but unfortunately introduce a regression on wpa-none.

With mwifiex backport driver of Linux 4.1  is not working, I mean the
link seems to be established always even when the password is wrong.

I saw on older thread on linux wireless with similar issue but more
related to fix ibss-rns, but with my test ibss-rns never worked with
mwifiex as with intranet one, so I think will be more important fix
the regression with wpa-none.


[1] https://www.u-blox.com/sites/default/files/EVK-EMMY-W1_UserGuide_%28UBX-15012713%29.pdf

Thanks and Regards,
Federico

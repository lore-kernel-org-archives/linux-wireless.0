Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:38964 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752643AbcHWUMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 16:12:30 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
        amitoj1606@gmail.com, bhaktipriya96@gmail.com, bhumirks@gmail.com,
        ksenija.stanojevic@gmail.com, mail@beyermatthias.de,
        meleodr@gmail.com, shivanib134@gmail.com
Subject: [PATCH] drivers: staging: rtl823au: hal: Remove pointless test
Date: Tue, 23 Aug 2016 21:44:16 +0200
Message-Id: <20160823194417.30531-1-mail@beyermatthias.de> (sfid-20160823_221240_627700_FD35ADB7)
In-Reply-To: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
References: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
In-Reply-To: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
References: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by David Binderman, this test is useless as of

    if (a < 3) {
        /* ... */
    } else if (a >= 3) {
        /* ... */
    }

so this patch removes the second check.

Matthias Beyer (1):
  drivers: staging: rtl8723au: hal: Remove pointless test

 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.9.2

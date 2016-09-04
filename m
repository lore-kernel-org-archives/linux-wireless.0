Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:43889 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752563AbcIDLC2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 07:02:28 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: Matthias Beyer <mail@beyermatthias.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        shivanib134@gmail.com, ksenija.stanojevic@gmail.com,
        Jes.Sorensen@redhat.com, meleodr@gmail.com,
        bhaktipriya96@gmail.com, bhumirks@gmail.com,
        Larry.Finger@lwfinger.net
Subject: [PATCH v2 0/1] Remove pointless test
Date: Sun,  4 Sep 2016 13:01:19 +0200
Message-Id: <20160904110120.27028-1-mail@beyermatthias.de> (sfid-20160904_130246_410433_1599B40A)
In-Reply-To: <20160901155447.GB7979@kroah.com>
References: <20160901155447.GB7979@kroah.com>
In-Reply-To: <20160901155447.GB7979@kroah.com>
References: <20160901155447.GB7979@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-sending as

On 01-09-2016 17:54:47, Greg KH wrote:
> There is no patch here :(

----8<----

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
2.9.3

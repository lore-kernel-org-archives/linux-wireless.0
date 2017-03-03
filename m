Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.181]:58507 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbdCCRB3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 12:01:29 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: 'Andrey Ryabinin' <aryabinin@virtuozzo.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>
CC: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-build-reports@lists.linaro.org"
        <kernel-build-reports@lists.linaro.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH 01/26] compiler: introduce noinline_for_kasan annotation
Date: Fri, 3 Mar 2017 16:34:26 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DCFE74524@AcuExch.aculab.com> (sfid-20170303_180257_003326_3E190172)
References: <20170302163834.2273519-1-arnd@arndb.de>
 <20170302163834.2273519-2-arnd@arndb.de>
 <7e7a62de-3b79-6044-72fa-4ade418953d1@virtuozzo.com>
In-Reply-To: <7e7a62de-3b79-6044-72fa-4ade418953d1@virtuozzo.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Ryabinin
> Sent: 03 March 2017 13:50
...
> noinline_iff_kasan might be a better name.  noinline_for_kasan gives the impression
> that we always noinline function for the sake of kasan, while noinline_iff_kasan
> clearly indicates that function is noinline only if kasan is used.

noinline_if_stackbloat

	David

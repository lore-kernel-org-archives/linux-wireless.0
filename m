Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53964 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933777AbdJRKRQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Oct 2017 06:17:16 -0400
Message-ID: <1508321831.2674.12.camel@sipsolutions.net> (sfid-20171018_121722_764561_BFB3A23B)
Subject: Re: [PATCH] mac80211: use constant time comparison with keys
From: Johannes Berg <johannes@sipsolutions.net>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Wed, 18 Oct 2017 12:17:11 +0200
In-Reply-To: <20171017183207.23124-1-Jason@zx2c4.com>
References: <CAHmME9qd_m-FDj1E+eiBYWKvnMBvr0tWVcJ4ph2tr=Y1d_tb1g@mail.gmail.com>
         <20171017183207.23124-1-Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-17 at 20:32 +0200, Jason A. Donenfeld wrote:
> Otherwise we risk leaking information via timing side channel.
> 
Applied.

johannes

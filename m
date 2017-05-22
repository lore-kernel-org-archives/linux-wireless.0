Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45776 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751425AbdEVGLV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 02:11:21 -0400
Message-ID: <1495433473.2653.0.camel@sipsolutions.net> (sfid-20170522_081126_473016_C746D1D1)
Subject: Re: [PATCH] ath10k : Fix channel survey dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "nbd@nbd.name" <nbd@nbd.name>,
        Venkateswara Naralasettty <vnaralas@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 22 May 2017 08:11:13 +0200
In-Reply-To: <CAJ-Vmok6UXVpYfK5c_tDnFGN1uLfx+sGp0W2zFppB=TYtax72g@mail.gmail.com> (sfid-20170519_173300_356433_4FB5D671)
References: <1493217698-22451-1-git-send-email-c_vnaral@qti.qualcomm.com>
         <40f2b7a2-7276-6de6-afc6-407348c92e70@nbd.name>
         <87wp9durwe.fsf@kamboji.qca.qualcomm.com>
         <CAJ-Vmok6UXVpYfK5c_tDnFGN1uLfx+sGp0W2zFppB=TYtax72g@mail.gmail.com>
         (sfid-20170519_173300_356433_4FB5D671)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-05-19 at 08:32 -0700, Adrian Chadd wrote:
> 
> I just bumped into this at work. I'm thinking of teaching mac80211
> about optionally summing things so each driver doesn't need another
> per-channel array.
> 

We could possibly even do that in cfg80211, I guess.

johannes

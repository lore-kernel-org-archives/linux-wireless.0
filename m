Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42743 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933065AbcI3Mt3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 08:49:29 -0400
Message-ID: <1475239765.17481.61.camel@sipsolutions.net> (sfid-20160930_144932_871436_0F76EE34)
Subject: Re: [PATCH v9 2/2] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Fri, 30 Sep 2016 14:49:25 +0200
In-Reply-To: <20160922170420.5193-3-toke@toke.dk> (sfid-20160922_190458_746453_8124AE7E)
References: <20160922170420.5193-1-toke@toke.dk>
         <20160922170420.5193-3-toke@toke.dk> (sfid-20160922_190458_746453_8124AE7E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applied, with the nits fixed as discussed.

Come to think of it, if somebody is bored ;-) perhaps a hwsim option to
use TXQs (should be optional I guess) would be nice so we can exercise
this code with the wpa_supplicant hwsim tests. That would have caught
the TKIP issues etc. pretty early on too, I think.

johannes

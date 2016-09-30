Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42308 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbcI3LNV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 07:13:21 -0400
Message-ID: <1475233995.17481.37.camel@sipsolutions.net> (sfid-20160930_131326_100402_88BB1861)
Subject: Re: [PATCH v9 1/2] mac80211: Move ieee802111_tx_dequeue() to later
 in tx.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Fri, 30 Sep 2016 13:13:15 +0200
In-Reply-To: <20160922170420.5193-2-toke@toke.dk> (sfid-20160922_190456_435847_847DCAEB)
References: <20160922170420.5193-1-toke@toke.dk>
         <20160922170420.5193-2-toke@toke.dk> (sfid-20160922_190456_435847_847DCAEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-22 at 19:04 +0200, Toke Høiland-Jørgensen wrote:
> The TXQ path restructure requires ieee80211_tx_dequeue() to call TX
> handlers and parts of the xmit_fast path. Move the function to later
> in tx.c in preparation for this.
> 
Applied.

johannes

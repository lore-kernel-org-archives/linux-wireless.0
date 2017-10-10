Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33774 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932191AbdJJPyy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 11:54:54 -0400
Message-ID: <1507650891.26041.71.camel@sipsolutions.net> (sfid-20171010_175734_170267_73518FE4)
Subject: Re: [RFC 2/3] ath9k: Move to mac80211 TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 10 Oct 2017 17:54:51 +0200
In-Reply-To: <20171010140208.1515-2-toke@toke.dk> (sfid-20171010_160341_629286_01B5926E)
References: <20171010140208.1515-1-toke@toke.dk>
         <20171010140208.1515-2-toke@toke.dk> (sfid-20171010_160341_629286_01B5926E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 16:02 +0200, Toke Høiland-Jørgensen wrote:
> This removes TXQ scheduling from ath9k and changes it to use the
> mac80211 TXQ scheduling API introduced in the previous patch.

I can't really comment on this, but I'll note that the patches need to
be all combined into a single one eventually, so that it compiles.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50088 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933408AbcLMPJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 10:09:22 -0500
Message-ID: <1481641759.20412.0.camel@sipsolutions.net> (sfid-20161213_160925_936466_5B0BC83D)
Subject: Re: [PATCH v2] mac80211: Ensure enough headroom when forwarding
 mesh pkt
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 13 Dec 2016 16:09:19 +0100
In-Reply-To: <1ffe01100a724290ab910d68980604ba@ceva-dsp.com> (sfid-20161207_111435_589586_8DB320B6)
References: <1ffe01100a724290ab910d68980604ba@ceva-dsp.com>
         (sfid-20161207_111435_589586_8DB320B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-12-07 at 09:59 +0000, Cedric Izoard wrote:
> When a buffer is duplicated during MESH packet forwarding,
> this patch ensures that the new buffer has enough headroom.

Applied.

johannes

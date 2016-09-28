Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58223 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752781AbcI1WK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 18:10:28 -0400
Message-ID: <1475100618.21839.2.camel@sipsolutions.net> (sfid-20160929_001031_639571_B50D00C2)
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Michael Braun <michael-dev@fami-braun.de>, kvalo@codeaurora.org,
        akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        projekt-wlan@fem.tu-ilmenau.de
Date: Thu, 29 Sep 2016 00:10:18 +0200
In-Reply-To: <wrfjoa38aqi3.fsf@redhat.com>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
         <wrfja8esdpcb.fsf@redhat.com> <1475076763.4139.42.camel@sipsolutions.net>
         <wrfj1t04c9ug.fsf@redhat.com> <1475077359.4139.44.camel@sipsolutions.net>
         <wrfjoa38aqi3.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-09-28 at 13:22 -0400, Jes Sorensen wrote:
> I'll still argue this could be handled better through gradual
> migration rather than one large patch that touches too many places, 

I'd agree if it was actually a large patch, but if at all, I have to
coordinate only with Kalle, which won't be difficult.

Comparing that to the alternative - introducing new API, changing all
the users in separate patches, and finally removing the old API - and
the nightmare of coordinating that going in through various different
trees, I'll take this any day. :)

johannes

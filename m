Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:49814 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbeIJNQU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 09:16:20 -0400
Message-ID: <1536567800.3224.39.camel@sipsolutions.net> (sfid-20180910_102332_042865_558DC693)
Subject: Re: [PATCH RFC v3 3/4] cfg80211: Add airtime statistics and settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 10:23:20 +0200
In-Reply-To: <153635897088.14170.10601367738164730253.stgit@alrua-x1> (sfid-20180908_002305_769585_4A855C77)
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897088.14170.10601367738164730253.stgit@alrua-x1>
         (sfid-20180908_002305_769585_4A855C77)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-09-08 at 00:22 +0200, Toke Høiland-Jørgensen wrote:
> This adds airtime statistics to the cfg80211 station dump, and also adds a new
> parameter to set the airtime weight of each station. The latter allows userspace
> to implement policies for different stations by varying their weights.

Maybe some documentation on the weights - both for other implementers as
well as users - would be useful.

> + * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station
> + *      (u16, usec)

how could the weight be in usec? copy/paste issue?

johannes

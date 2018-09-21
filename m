Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:33340 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbeIUUBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 16:01:11 -0400
Message-ID: <1537539112.4584.2.camel@sipsolutions.net> (sfid-20180921_161209_519374_BE4A2BC1)
Subject: Re: [RFC v2] mac80211: budget outstanding airtime for transmission
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Kan Yan <kyan@google.com>
Date: Fri, 21 Sep 2018 16:11:52 +0200
In-Reply-To: <87r2hnhv9q.fsf@toke.dk>
References: <1537470331-6270-1-git-send-email-rmanohar@codeaurora.org>
         <8d8e3775-4504-7b37-19b0-4a7fae054d12@nbd.name> <87r2hnhv9q.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 1. Make sure packets are not freed after dequeue (probably not
> feasible).

We already require you free via mac80211 after TX, so could tie into
that for adjustment?

johannes

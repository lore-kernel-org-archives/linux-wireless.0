Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38270 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3BKJ2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 04:28:43 -0500
Received: by mail-wi0-f172.google.com with SMTP id ez12so2883384wid.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 01:28:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360572417.8738.4.camel@jlt4.sipsolutions.net>
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com> <1360225230.8038.1.camel@jlt4.sipsolutions.net>
 <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com>
 <1360228991.8038.3.camel@jlt4.sipsolutions.net> <CABPxzYLwEfzwS9b8dAGjbqT2MLo9FdTKkRwWKDvzxp82ObB-9Q@mail.gmail.com>
 <5113B42A.4020708@openwrt.org> <1360246653.8038.9.camel@jlt4.sipsolutions.net>
 <CABPxzYJG3xP0_Wy-1HMjWx-YoHp5WmhrfBH5vBvOJ4WQ_7Nzrg@mail.gmail.com>
 <5113C5E0.5050509@openwrt.org> <1360250827.8038.10.camel@jlt4.sipsolutions.net>
 <CABPxzYLY5-MmePjUUGedC4rT88b328u7AKOeHREuF11BuOjYGA@mail.gmail.com> <1360572417.8738.4.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 11 Feb 2013 14:58:22 +0530
Message-ID: <CABPxzY+LG+Gd9JM+do=+Fsm-t1KxTuNyOMB7d67fHf6sxTjQ-Q@mail.gmail.com> (sfid-20130211_102847_872353_2EF90412)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>, chaitanyatk@posedge.com,
	linux-wireless@vger.kernel.org, maheshp@posedge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 11, 2013 at 2:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-02-11 at 13:24 +0530, Krishna Chaitanya wrote:
>> On Thu, Feb 7, 2013 at 8:57 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Thu, 2013-02-07 at 16:18 +0100, Felix Fietkau wrote:

> You should be able to patch this very easily to preserve the A-MSDU bit,
> which won't matter in the normal case where it's always cleared.

Will give it a try locally and share the patch. Thanks.

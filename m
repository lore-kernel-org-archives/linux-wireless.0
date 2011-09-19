Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52436 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab1ISVy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:54:58 -0400
Received: by qyk30 with SMTP id 30so3223505qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 14:54:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6XLdftXKg5-wvme8Vg7BjGi-TpxQ3G6m=7VnEw89YzXoA@mail.gmail.com>
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org>
 <1316453903-75710-2-git-send-email-nbd@openwrt.org> <CAB=NE6XvanRQ6Yje_qHhkfzbLmZn9o5Q+5y1NobJwCyuMLFEvg@mail.gmail.com>
 <4E77AAFB.1080805@openwrt.org> <CAB=NE6XgSz7zz_ZXaPQEsaue307ipd7Qnzgi5QWr8Y4SS1j=Lg@mail.gmail.com>
 <4E77B25D.9070907@openwrt.org> <CAB=NE6XLdftXKg5-wvme8Vg7BjGi-TpxQ3G6m=7VnEw89YzXoA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 19 Sep 2011 14:54:37 -0700
Message-ID: <CAB=NE6XQDqG+En2KWOyKGUVT1SWm1rwMwOxMjpE8CjYfvwvOqw@mail.gmail.com> (sfid-20110919_235504_704262_1BAD6A65)
Subject: Re: [PATCH v2 2/4] ath9k_hw: clean up tx power handling
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 2:45 PM, Luis R. Rodriguez
<mcgrof@qca.qualcomm.com> wrote:
> On Mon, Sep 19, 2011 at 2:21 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> I looked at the other ath driver and I see no indication that it's related
>> to DFS in any way.
>
> I have verified this just now as well, it seems it was only used to
> support an ioctl to userspace to enable users to update a tpscale
> value but I see no documentation about this. Next question is who in
> usersapce sets this. I wonder if its done through userspace after
> measuring some TPC reports from STAs.

So this comes from supporting a "TR-098" specification, which seems to
be the "Internet Gateway Device data model for the CPE WAN Management
Protocol". I haven't yet been able to map this to the specification
respective component:

http://www.broadband-forum.org/technical/download/TR-098.pdf

  Luis

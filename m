Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36632 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab2EYCCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 22:02:55 -0400
Message-ID: <4FBEE849.9020602@openwrt.org> (sfid-20120525_040303_308928_BE5E2B63)
Date: Fri, 25 May 2012 04:02:49 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat: rename compat-3.5.c to compat-3.4.c
References: <1337866168-11749-1-git-send-email-nbd@openwrt.org> <CAB=NE6WzN3wv=n_+oX+EQhvuNKg6mH-wavEygpDS+pbKouVA3A@mail.gmail.com>
In-Reply-To: <CAB=NE6WzN3wv=n_+oX+EQhvuNKg6mH-wavEygpDS+pbKouVA3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-25 2:51 AM, Luis R. Rodriguez wrote:
> On Thu, May 24, 2012 at 6:29 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> It only contains simple_open, which is already available on Linux 3.4.
>> Fixes duplicate symbol issues on 3.4
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> Thanks! The equivalent change was required from
> include/linux/compat-3.5.h to include/linux/compat-3.4.h, I took care
> of that though, merged and I'll push this shortly!
Yeah, v2 had that as well.

- Felix

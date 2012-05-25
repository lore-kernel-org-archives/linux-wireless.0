Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47808 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2EYCEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 22:04:04 -0400
Received: by obbtb18 with SMTP id tb18so551922obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2012 19:04:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBEE849.9020602@openwrt.org>
References: <1337866168-11749-1-git-send-email-nbd@openwrt.org>
 <CAB=NE6WzN3wv=n_+oX+EQhvuNKg6mH-wavEygpDS+pbKouVA3A@mail.gmail.com> <4FBEE849.9020602@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 24 May 2012 19:03:43 -0700
Message-ID: <CAB=NE6Vnre3Giyz1qEMRa-o8XkhDbyyEmU_FUG9Ge6HCOzDrYQ@mail.gmail.com> (sfid-20120525_040408_793180_3D474AEB)
Subject: Re: [PATCH] compat: rename compat-3.5.c to compat-3.4.c
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2012 at 7:02 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-05-25 2:51 AM, Luis R. Rodriguez wrote:
>> On Thu, May 24, 2012 at 6:29 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> It only contains simple_open, which is already available on Linux 3.4.
>>> Fixes duplicate symbol issues on 3.4
>>>
>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>
>> Thanks! The equivalent change was required from
>> include/linux/compat-3.5.h to include/linux/compat-3.4.h, I took care
>> of that though, merged and I'll push this shortly!
> Yeah, v2 had that as well.

Oops I didn't see that, thanks!

  Luis

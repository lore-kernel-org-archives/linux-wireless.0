Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41871 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab2BATOm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 14:14:42 -0500
Message-ID: <4F298F19.7000102@hauke-m.de> (sfid-20120201_201445_632264_B65AF5A9)
Date: Wed, 01 Feb 2012 20:14:33 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] compat: add __cancel_delayed_work()
References: <1327153475-28081-1-git-send-email-hauke@hauke-m.de> <CAB=NE6UBBRg53EjW3t8YEUoGLvQS00dnx6Z=-rmBa7pb-D_TCg@mail.gmail.com>
In-Reply-To: <CAB=NE6UBBRg53EjW3t8YEUoGLvQS00dnx6Z=-rmBa7pb-D_TCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2012 06:31 PM, Luis R. Rodriguez wrote:
> On Sat, Jan 21, 2012 at 5:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> __cancel_delayed_work is needed by include/net/bluetooth/l2cap.h and
>> not available in old kernel versions. This was just copied from the
>> kernel.
>>
>> This should also go into compat-wireless-stable-3.3.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> Thanks! Applied all onto compat-wireless.git and compat.git, in
> addition to the linux-3.3.y branch for compat.git as you indicated for
> this patch. Will roll out a new tarball right away.
> 
>   Luis

This patch is not in the master branch of compat, it is just in the
linux-3.3.y branch. Could you please add this to master.
It is commit ed1b6816e893ee7a158ecd30687970faf4facc21 in linux-3.3.y.

Hauke

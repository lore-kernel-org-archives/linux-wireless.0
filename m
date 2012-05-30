Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45294 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab2E3JrH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 05:47:07 -0400
Message-ID: <4FC5EC90.70200@hauke-m.de> (sfid-20120530_114711_859551_9A1ECA23)
Date: Wed, 30 May 2012 11:46:56 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/8] compat-wireless: make patches apply again
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de> <1338331182-29589-2-git-send-email-hauke@hauke-m.de> <CAB=NE6XuJKkZTAABX614eih7Okn68hj_RD_MSLv1Xg18Jy1d4g@mail.gmail.com> <CAB=NE6WgLbv+vx2V2nZ-W+8wtz_1JfooYxF99oDaLH8q33Np8Q@mail.gmail.com>
In-Reply-To: <CAB=NE6WgLbv+vx2V2nZ-W+8wtz_1JfooYxF99oDaLH8q33Np8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 02:03 AM, Luis R. Rodriguez wrote:
> On Tue, May 29, 2012 at 4:16 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Tue, May 29, 2012 at 3:39 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>
>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>
>> Oops, I had just pushed out some changes to make patches apply but --
>> I hadn't started to address compilation yet, I think just patch 1
>> addresses application of patches, the rest seem to address compilation
>> so I'll try to apply the rest of the series. If you can rebase that'd
>> be great, I'll stop doing stuff right away.
> 
> Actually I managed to apply them all, test compiling now!
> 
>   Luis
Hi Luis,

thanks for merging my patches in.
While doing a diff between my branch and yours I found one problem, I
will send  a patch for it.

Hauke

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762142Ab2DLH4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 03:56:06 -0400
Received: by iagz16 with SMTP id z16so2461371iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 00:56:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334204193.3788.14.camel@jlt3.sipsolutions.net>
References: <1333746034.5577.10.camel@jlt3.sipsolutions.net>
 <CAB=NE6XMuaAPFPfKGunrGuqnYLKfem35Q3nXiEpc7u23FM14ng@mail.gmail.com> <1334204193.3788.14.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 12 Apr 2012 00:55:45 -0700
Message-ID: <CAB=NE6UJS=dnUO0Cq-7Kve+7ofnbW-XkGHqCQCf+HzEMTRn8WQ@mail.gmail.com> (sfid-20120412_095610_070876_9D11A05B)
Subject: Re: [PATCH] compat: backport netif_wake_subqueue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2012 at 9:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-04-06 at 19:23 -0700, Luis R. Rodriguez wrote:
>> On Fri, Apr 6, 2012 at 2:00 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > Kernels 2.6.23 - 2.6.27 had some multiqueue support,
>> > but called netif_wake_subqueue netif_start_subqueue.
>> > So to backport, just add a define.
>> >
>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>
>> Applied and pushed, and tested with ckmake, thanks!
>
> I don't see this, did you move the repository off infradead?

Sorry, I forgot to push to infra, the most reliable tree is on github.
I use infra as backup.

  Luis

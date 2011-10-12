Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46217 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab1JLJNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 05:13:32 -0400
Received: by qyk30 with SMTP id 30so4495687qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 02:13:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318408634.3933.32.camel@jlt3.sipsolutions.net>
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1318355944-24708-8-git-send-email-mcgrof@qca.qualcomm.com>
 <1318363042.15357.0.camel@jlt3.sipsolutions.net> <CAB=NE6WtkokxWg4zJtjyKVZmhZAhzArfoJuOOqhuKSw940hxqg@mail.gmail.com>
 <1318408634.3933.32.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Wed, 12 Oct 2011 02:13:11 -0700
Message-ID: <CAB=NE6XBwgxP+v5mK_XLfTZp+8Zgqah-RpF1dCy+rpGxgdp+2w@mail.gmail.com> (sfid-20111012_111335_680630_0B97931C)
Subject: Re: [PATCH] iw: add DFS region parsing support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2011 at 1:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-10-11 at 13:25 -0700, Luis R. Rodriguez wrote:
>
>> > Also, I prefer patches w/o nl80211.h updates.
>>
>> In my RFC on December the stars aligned differently and you preferred
>> it together I think.
>
> Really? I must've been confused. The reason I don't want them is that
> then I can never merge something that isn't upstream yet. :)

That's fine, I also like to split it. I'll resend the iw patches.
John, let me know if the other ones look peachy, once and if you merge
to wireless-regdb, wireless-next I'll push to CRDA too.

  Luis

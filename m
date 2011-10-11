Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49047 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab1JKUZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 16:25:28 -0400
Received: by vcbgb30 with SMTP id gb30so2017742vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 13:25:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318363042.15357.0.camel@jlt3.sipsolutions.net>
References: <1318355944-24708-1-git-send-email-mcgrof@qca.qualcomm.com>
 <1318355944-24708-8-git-send-email-mcgrof@qca.qualcomm.com> <1318363042.15357.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 11 Oct 2011 13:25:07 -0700
Message-ID: <CAB=NE6WtkokxWg4zJtjyKVZmhZAhzArfoJuOOqhuKSw940hxqg@mail.gmail.com> (sfid-20111011_222531_375829_1E247A80)
Subject: Re: [PATCH] iw: add DFS region parsing support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2011 at 12:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-10-11 at 10:59 -0700, Luis R. Rodriguez wrote:
>
>> +     default:
>> +             printf("Uknown");
>
> typo.

Will fix.

> Also, I prefer patches w/o nl80211.h updates.

In my RFC on December the stars aligned differently and you preferred
it together I think.

  Luis

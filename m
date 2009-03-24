Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:35994 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZCXXOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 19:14:12 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3682850wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 16:14:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090324223022.M51759@bobcopeland.com>
References: <200903241938.47155.chunkeey@web.de> <200903242133.28405.chunkeey@web.de>
	<20090324205847.GB29268@tesla> <200903242324.33485.chunkeey@web.de>
	<20090324223022.M51759@bobcopeland.com>
Date: Tue, 24 Mar 2009 16:13:55 -0700
Message-ID: <43e72e890903241613x6e6de1ecp909ee6f4156ba709@mail.gmail.com> (sfid-20090325_001416_607585_169D5CB4)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 3:30 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, 24 Mar 2009 23:24:33 +0100, Christian Lamparter wrote
>
>> > Nice....... so it seems all we need now is ath5k figured out and properly
>> > tested.
>> uhh, looks like ath5k/regd.c got dropped by accident?!
>
> Well, it wasn't working when I had it either :)

My brain is fuzzy here but I think I had decided to not have an
ath5k/regd.c. Hm but I see the file there now in my tree.

Anyway we should get a newer shinier patch which has all these changes
so far + ar9170 changes and test them. Whoever gets to it first please
post one.

  Luis

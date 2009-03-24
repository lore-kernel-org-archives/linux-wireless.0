Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:35082 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbZCXXw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 19:52:27 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3698654wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 16:52:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903241617i629a4c75of573bb7f77572ade@mail.gmail.com>
References: <200903241938.47155.chunkeey@web.de> <200903242133.28405.chunkeey@web.de>
	<20090324205847.GB29268@tesla> <200903242324.33485.chunkeey@web.de>
	<20090324223022.M51759@bobcopeland.com> <43e72e890903241613x6e6de1ecp909ee6f4156ba709@mail.gmail.com>
	<43e72e890903241617i629a4c75of573bb7f77572ade@mail.gmail.com>
Date: Tue, 24 Mar 2009 16:52:09 -0700
Message-ID: <43e72e890903241652o70aa8e2bjd40a5ae9a4ebc91a@mail.gmail.com> (sfid-20090325_005243_546371_08E3D59E)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 4:17 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Mar 24, 2009 at 4:13 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Tue, Mar 24, 2009 at 3:30 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>> On Tue, 24 Mar 2009 23:24:33 +0100, Christian Lamparter wrote
>>>
>>>> > Nice....... so it seems all we need now is ath5k figured out and properly
>>>> > tested.
>>>> uhh, looks like ath5k/regd.c got dropped by accident?!
>>>
>>> Well, it wasn't working when I had it either :)
>>
>> My brain is fuzzy here but I think I had decided to not have an
>> ath5k/regd.c. Hm but I see the file there now in my tree.
>
> Ah yes, brain_works_still++, the file was not in the commit log and I
> did move things into the driver elsewhere.

Alright here's a quick concat of all these patches (also one small
sparse fix on Christian's last patch). It also now throws ath5k, ath9k
and ar9170 into ath/. We can rename the drivers after, was lazy to do
that. Think its easier for review to separate that too.

http://bombadil.infradead.org/~mcgrof/patches/ath/ath-common-v3.patch.txt

Bob, where was that switch break error?

  Luis

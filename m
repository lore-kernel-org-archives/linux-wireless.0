Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:33201 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZCZRVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:21:51 -0400
Received: by wf-out-1314.google.com with SMTP id 29so791103wff.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 10:21:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238081639.4331.63.camel@johannes.local>
References: <1238066858.4331.30.camel@johannes.local> <b6c5339f0903260741i33264d5dy5e48a5c182cce387@mail.gmail.com>
	<1238078762.4331.38.camel@johannes.local> <b6c5339f0903260826t58c8c595ve612fa35ba7c91e4@mail.gmail.com>
	<1238081639.4331.63.camel@johannes.local>
Date: Thu, 26 Mar 2009 10:21:34 -0700
Message-ID: <43e72e890903261021n3e3a5ec4kc7da7da229b10ed5@mail.gmail.com> (sfid-20090326_182155_374700_225487C5)
Subject: Re: [PATCH] mac80211: add driver ops debugging
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 8:33 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-03-26 at 11:26 -0400, Bob Copeland wrote:
>> On Thu, Mar 26, 2009 at 10:46 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >> Could we use some newfangled thing like tracepoints for this
>> >> instead of printk? =C2=A0Disclaimer: I know nothing about such
>> >> things.
>> >
>> > Probably. Want to look at how to do that? :)
>>
>> Sure, I'll do some research and see what's involved. =C2=A0Don't hol=
d
>> up the patch on my account though.
>
> Oh doesn't matter to me -- I was posting it more because I did it, I
> don't have an immediate need to have it included. If you want to take
> some time to look into that we can hold the patch without any trouble=
, I
> agree it would probably be nicer, just didn't work with any of that
> stuff before so I didn't even think of it.

Might be nice to have a debugfs entry and en enable/disable target for
each, then you can just enable the trace prints on the ones you need.
Just throwing that out there.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

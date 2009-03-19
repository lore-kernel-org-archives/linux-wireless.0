Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:3753 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZCSJpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 05:45:23 -0400
Received: by rv-out-0506.google.com with SMTP id f9so484420rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 02:45:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237455413.5100.55.camel@johannes.local>
References: <1237442241-29803-1-git-send-email-lrodriguez@atheros.com>
	 <43e72e890903182310o58cf15f9yeeba8c86c45627d7@mail.gmail.com>
	 <1237454341.5100.52.camel@johannes.local>
	 <43e72e890903190225q22a0e46ap1c3f7fa5f1463d9e@mail.gmail.com>
	 <1237455413.5100.55.camel@johannes.local>
Date: Thu, 19 Mar 2009 02:45:21 -0700
Message-ID: <43e72e890903190245r68003a45q2ce05e0ddeabc033@mail.gmail.com> (sfid-20090319_104526_554185_1672D85A)
Subject: Re: [PATCH] iw: add support to print HT40-/+ on channels
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2009 at 2:36 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-03-19 at 02:25 -0700, Luis R. Rodriguez wrote:
>
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 * 2432 MHz [5] (27.0 dBm / 20 MHz)
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 * 2437 MHz [6] (27.0 dBm / 20 MHz)
>> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 * 2442 MHz [7] (27.0 dBm / 20 MHz)
>
>> > Eh, that doesn't look right. What's with 2432-2443 MHz?
>>
>> It means you get HT40-/+ allowed. Do we want to show if we have it a=
llowed?
>
> What's with the /20mhz though?

Right, so that would mean you're clear regulatory wise to use the
entire 20 MHz for that channel. At a later time perhaps a custom
target bandwidth might be desired, then the regulatory bandwidth check
could be reduced. I'm not sure how we'll do this yet but if we keep
the bandwidth this lets us keep the max per channel and then easily
determine which smaller target bandwidths would be allowed.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

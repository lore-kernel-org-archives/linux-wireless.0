Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:44344 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbYIIKVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 06:21:52 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1094380yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 03:21:51 -0700 (PDT)
Message-ID: <1ba2fa240809090321w4d2f3780g32e9507fac45f95e@mail.gmail.com> (sfid-20080909_122157_345764_4E826AB4)
Date: Tue, 9 Sep 2008 13:21:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: HT action frame code
Cc: "Jouni Malinen" <j@w1.fi>,
	"Ron Rindjunsky" <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220954146.31304.127.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220883730.31304.60.camel@johannes.berg>
	 <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
	 <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com>
	 <1220954146.31304.127.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 12:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-09-09 at 12:52 +0300, Tomas Winkler wrote:
>
>> > Well yes, but that just triggers when aggregation on our end, what I'd
>> > been thinking about was when the remote side wants to start aggregation.
>>
>> There is some misunderstanding. I hope I'm explaining the problematic
>> part.  Aggregation is always initialized by TX side it's one direction
>> only. So if there AP and STA wants to start aggregation. Both will
>> open a stream. The streams are independent.
>
> Right. And if mac80211 is the AP, then I don't see how the STA can start
> aggregation since I couldn't find where the relevant action frames are
> handled. But you said it's not part of the code now, so I couldn't find
> it anyway.

That's probably the current situation.
Tomas

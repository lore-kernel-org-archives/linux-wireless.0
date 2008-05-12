Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:13686 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYELQzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 12:55:06 -0400
Received: by an-out-0708.google.com with SMTP id d40so487193and.103
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 09:55:05 -0700 (PDT)
Message-ID: <43e72e890805120955n49697895j97b5e9f79de92af2@mail.gmail.com> (sfid-20080512_185512_189310_4CF5E788)
Date: Mon, 12 May 2008 09:55:05 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Patrick McHardy" <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: prism54: revert "prism54: set carrier flags correctly"
In-Reply-To: <43e72e890805120952q5abca0c3sfe49dedd97ed772e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48287189.8080706@trash.net>
	 <43e72e890805120952q5abca0c3sfe49dedd97ed772e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oh and if you're wondering how im sending this, its through GPRS on my
trusty bb and through my trusty gmail :) so I do have at least "some"
level of interweb access..

Now if only I could hack on this too...



On 5/12/08, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu> wrote:
> Patick, thanks for staying on top of this, however NACK. The fix I
> sumbitted and you tested should be merged. I nagged about it too, John
> just wanted a resubmit with a log message.
>
> John please accept the patch I posted, sorry I'd resend and add a nice
> commit log message but I've been away from interweb access for a few
> days now and expect it to be this way for the next two days.
>
> You can add something like "this fixes a regression introduced by $SHA1_SUM"
>
> Thanks,
>
>   Luis
>
>
>
> On 5/12/08, Patrick McHardy <kaber@trash.net> wrote:
> >
>
> --
> Sent from Gmail for mobile | mobile.google.com
>

-- 
Sent from Gmail for mobile | mobile.google.com

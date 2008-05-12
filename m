Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:51743 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYELQwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 12:52:18 -0400
Received: by wr-out-0506.google.com with SMTP id c48so799453wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 09:52:17 -0700 (PDT)
Message-ID: <43e72e890805120952q5abca0c3sfe49dedd97ed772e@mail.gmail.com> (sfid-20080512_185220_309110_153F09E0)
Date: Mon, 12 May 2008 09:52:16 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Patrick McHardy" <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, "Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: prism54: revert "prism54: set carrier flags correctly"
In-Reply-To: <48287189.8080706@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48287189.8080706@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patick, thanks for staying on top of this, however NACK. The fix I
sumbitted and you tested should be merged. I nagged about it too, John
just wanted a resubmit with a log message.

John please accept the patch I posted, sorry I'd resend and add a nice
commit log message but I've been away from interweb access for a few
days now and expect it to be this way for the next two days.

You can add something like "this fixes a regression introduced by $SHA1_SUM"

Thanks,

  Luis



On 5/12/08, Patrick McHardy <kaber@trash.net> wrote:
>

-- 
Sent from Gmail for mobile | mobile.google.com

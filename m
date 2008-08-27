Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:26306 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbYH0Lea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 07:34:30 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1533870fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2008 04:34:29 -0700 (PDT)
Message-ID: <1ba2fa240808270434y1589761xd2ff0a48c2e99033@mail.gmail.com> (sfid-20080827_133444_188175_1261A6F7)
Date: Wed, 27 Aug 2008 14:34:28 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: "Marcel Holtmann" <holtmann@linux.intel.com>,
	"David Miller" <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1219831828.3891.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080827013009.GA15781@tuxdriver.com>
	 <1ba2fa240808270038r24d5eeb9l36fd70ef5ae904f5@mail.gmail.com>
	 <20080827.014041.230100807.davem@davemloft.net>
	 <1219835410.5359.24.camel@californication>
	 <1ba2fa240808270305m7f505efak9fd0d36d5db09a1e@mail.gmail.com>
	 <1219831828.3891.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2008 at 1:10 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-08-27 at 13:05 +0300, Tomas Winkler wrote:
>
>> There is a central problem here, since I cannot really adjust driver
>> development progress from obvious reason with Linux merging window.
>> Upstream kernel is unfortunately not the only customer I report to. So
>> actually stable versions got half backed drivers depending on some
>> arbitrary time cut from my (selfish) development point of view.
>
> FWIW, many people including myself think you should work the other way
> around, that is develop things in the mainline/wireless-testing tree
> rather than developing a stable version internally
> big pile of patches whenever it's convenient for you.

We put big pile once the driver was functional and nobody expected it
to be merged into stable kernel from that point
we post everything that is mergable. The patches are sent out each
Friday after they got through internal review there is nothing, there
is nothing magical about it.

IOW, we think you
> should use Linux upstream as your development tree and then branch off
> of that for the internal stabilisation trees you need for other
> customers, rather than having some sort of internal development tree and
> branching out Linux upstream as you appear to work.

Unfortunately fixing bugs on stable branch take precedence  of
adjusting to new API on development branch that someone decided to do.
 I wanted to work directly on wireless testing but it was broken over
an over and I have only limited resources more in testing then in
development I just had to branch out to be ready with the driver when
HW is out. People just check the immediate impact of they fix the
don't test for collateral damage and this is understandable an
individual developer doesn't have lab with IBSS, BSS, AP, etc setups.

> That would also avoid the nasty surprises you've gotten a few times
> where other people managed to get patches to iwlwifi drivers into the
> Linux tree without you noticing.

I've noticed just deferred to fixing it.

In summary
This was my first Linux project, it was first project that was done on
new HW (nobody could test it but us)  and I don't deny I did a lot of
mistake in development process  I don't deny that and we are learning
from them.
Tomas

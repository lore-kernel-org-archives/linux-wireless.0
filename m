Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:21725 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbXGYIGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 04:06:30 -0400
Received: by wx-out-0506.google.com with SMTP id h31so107728wxd
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 01:06:30 -0700 (PDT)
Message-ID: <1ba2fa240707250106w43073bcbh1b4c7fa3d47fc3e2@mail.gmail.com>
Date: Wed, 25 Jul 2007 11:06:29 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1184777775.8125.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com>
	 <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
	 <1184754598.4658.14.camel@johannes.berg>
	 <1ba2fa240707180622p791168eax4fae712641e24cc4@mail.gmail.com>
	 <1ba2fa240707180851y22ead404g1c87d73903e939e3@mail.gmail.com>
	 <1184777775.8125.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-07-18 at 18:51 +0300, Tomas Winkler wrote:
>
> > > HT aggregtion is extension of QoS. Multicast and broadcast frames are
> > > not QoS frames and therefore such frames  want be incorporated into an
> > > A-MSDU.
> > Oops
> > s/want/won't/
>
> Ah, ok, I didn't bother to re-check. Mind doing a patch then that rips
> out this code?
>
> johannes
>
>
I've checked the Spec again and I was wrong. Theoretically,  A-MSDU
packet can be a multicast packet so we get back to the problem you've
pointed first.

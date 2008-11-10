Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52534 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYKJObI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 09:31:08 -0500
Date: Mon, 10 Nov 2008 09:28:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: David Shwatrz <dshwatrz@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: Where is allow-ap-vlan-modes.patch ?
Message-ID: <20081110142806.GG3546@tuxdriver.com> (sfid-20081110_153112_538468_9DD681F9)
References: <31436f4a0811090701r4676409er8f53a32c91bc3ced@mail.gmail.com> <200811091604.43705.IvDoorn@gmail.com> <31436f4a0811100048h5c7520d3ga4eedd815f8c793a@mail.gmail.com> <874p2g0x9d.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874p2g0x9d.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 10, 2008 at 11:02:22AM +0200, Kalle Valo wrote:
> David Shwatrz <dshwatrz@gmail.com> writes:
> 
> > In this occasion may I ask - what is the wireless-testing git tree?
> > is it based on wireless-next-2.6 or on wireless-2.6 tree?
> 
> It's based on Linus' rc releases and has all the wireless patches
> which have been under development. I think John cherry picks the
> patches from wireless-testing to wireless-2.6 or wireless-next-2.6. So
> wireless-testing contains the bleeding edge wireless patches and if
> John thinks they are good enough, he submits them forward.
> 
> Please correct me if I have understood something wrong.

That is basically right.

In the past patches often went to wireless-testing and to
wireless-next-2.6/wireless-2.6 at the about the same time.  However
upstream standards have tightened in ways that make me feel it is
appropriate to give patches more public testing even before sending
them for -next.

In this case, I was also sick all last week which has slowed thing
a bit more...

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

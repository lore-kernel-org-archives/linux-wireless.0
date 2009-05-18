Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35767 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbZERMpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 08:45:16 -0400
Date: Mon, 18 May 2009 08:38:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>,
	Jouni Malinen <j@w1.fi>
Subject: Re: Scan while TX/RX'ing a lot of data
Message-ID: <20090518123858.GA2814@tuxdriver.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com> <1242327298.4227.25.camel@localhost.localdomain> <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com> <1242334636.4227.134.camel@localhost.localdomain> <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com> <43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com> <1242478657.10005.72.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242478657.10005.72.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 16, 2009 at 02:57:37PM +0200, Johannes Berg wrote:

> Anyway, bottom line is that I don't think we should change the APIs in
> any way, we should instead make the scan smarter by spreading it out if
> we're active. This even applies to scanning while in an IBSS -- stop
> beaconing, then go scan etc.

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

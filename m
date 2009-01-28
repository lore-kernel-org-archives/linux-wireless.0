Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:41982 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZA1QtW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:49:22 -0500
Subject: Re: [PATCH 1/3] wireless: replace uses of __constant_{endian}
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	linux-netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240901280236j60d9956dy7527038429c2218a@mail.gmail.com>
References: <1233129609.6717.43.camel@brick>
	 <1ba2fa240901280236j60d9956dy7527038429c2218a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 08:49:20 -0800
Message-Id: <1233161360.6717.48.camel@brick> (sfid-20090128_174927_764978_5D0BDD05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-01-28 at 12:36 +0200, Tomas Winkler wrote:
> On Wed, Jan 28, 2009 at 10:00 AM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> > The base versions handle constant folding now.
> >
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> I guess It will be hard to rebase for iwlwifi, a lot of code was moved
> around in yestrday batch of patches.
> Since this change can be created with a simple script I suggest to
> make another patch on top of yestrday's ones.
> Tomas
> 

Sure, I worked against net-next, I'll redo the wireless bits against
the wireless tree in the next day or so.

Harvey


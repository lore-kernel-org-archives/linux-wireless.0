Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:49675 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2EGR47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 13:56:59 -0400
Date: Mon, 07 May 2012 13:55:47 -0400 (EDT)
Message-Id: <20120507.135547.704675228233645115.davem@davemloft.net> (sfid-20120507_195705_594108_33CAB0FC)
To: marcel@holtmann.org
Cc: dh.herrmann@googlemail.com, gustavo@padovan.org,
	linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336410360.5970.103.camel@aeonflux>
References: <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
	<20120506.145304.1998242927519675381.davem@davemloft.net>
	<1336410360.5970.103.camel@aeonflux>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 07 May 2012 10:06:00 -0700

> When it comes to function declaration and function calls, the style in
> mm/memory.c is mixed. We can start counting, but for both other
> multi-line cases it seems that tab-only indentation is predominant.

Fair enough.

But you know what the real issue is?

I have told the bluetooth folks this matters to me, repeatedly.

And then when I pushback when some unacceptable changes slip through,
they put a bullseye on my head and say I'm being unreasonable.

What's unreasonable about a maintainer telling you multiple times
to do things a certain way and then getting mad when you still
don't listen?

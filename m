Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34572 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZLJNig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 08:38:36 -0500
Received: by bwz27 with SMTP id 27so6065758bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 05:38:41 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, davem@davemloft.net
Subject: Re: Revised wireless tree management practices
References: <20091209211054.GB32058@tuxdriver.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 10 Dec 2009 15:38:38 +0200
Message-ID: <87ljhb0x0h.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> Greetings,

Hi,

> So I'm tired of a) being asked how wireless-testing is managed; and,
> b) having trouble explaining it.  I think it is time to move to a
> more conventional process for wireless patches.

Hopefully this also reduces your workload. There is quite a lot of
wireless patches floating around nowadays.

> More likely, it means I may have to push an occasional revert
> through those trees that I might have otherwise avoided.

Having reverts in the tree doesn't sound that bad. Even we do mistakes
sometimes, no need to hide them :)

> For now, the main change to wireless-testing will be that I will be
> pulling from wireless-2.6 and wireless-next-2.6 rather than reapplying
> most patches.  This should limit (and possibly eliminate) the confusing
> patch-revert-reapply-repeat practice I have been using there for a
> long time.  However, I still anticipate using w-t as a holding area
> for questionable patches.  So, at least some patches may still get
> the revert-reapply treatment.  I may ask Stephen to pull w-t into
> linux-next in order to expand testing of any such patches.

I have two questions:

What tree should I base my patches on?

What about testing? Which tree is best to use for testing latest and
greatest wireless patches?

-- 
Kalle Valo

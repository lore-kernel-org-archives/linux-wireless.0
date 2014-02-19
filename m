Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bob.fi ([81.209.35.21]:38020 "EHLO mail.bob.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbaBSPaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:30:12 -0500
Message-ID: <5304CDFB.2090202@mageia.org> (sfid-20140219_163017_767611_FBBA423F)
Date: Wed, 19 Feb 2014 17:30:03 +0200
From: Thomas Backlund <tmb@mageia.org>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Intel Wireless 7260 AC firnware SW error
References: <52FFDC10.5020702@mageia.org> <CANUX_P26bMLiPjjor6q960VC9RxhCagS7Je8S7hpzte1R52swA@mail.gmail.com>
In-Reply-To: <CANUX_P26bMLiPjjor6q960VC9RxhCagS7Je8S7hpzte1R52swA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


16.02.2014 08:29, Emmanuel Grumbach skrev:

> Can you please record tracing?
>
> trace-cmd record -e iwlwifi -e mac80211
>
> and try to reproduce?
>
> It may be a driver or a firmware issue, I can't really know with the
> current data.
> Thanks for reporting!

I can...

I assume this is the one you mean:
http://git.kernel.org/cgit/linux/kernel/git/rostedt/trace-cmd.git



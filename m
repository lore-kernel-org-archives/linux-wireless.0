Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33225 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248AbZJHXR0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 19:17:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2009-10-08
Date: Fri, 9 Oct 2009 01:16:44 +0200
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091008223454.GB2798@tuxdriver.com> <200910090108.08838.mb@bu3sch.de>
In-Reply-To: <200910090108.08838.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910090116.46513.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 October 2009 01:08:06 Michael Buesch wrote:
> On Friday 09 October 2009 00:34:54 John W. Linville wrote:
> > Albert Herranz (1):
> >       b43: do not stack-allocate pio rx/tx header and tail buffers
> 
> Come on, this is _not_ funny anymore. I did _not_ ack this patch, because I do _not_ like it.
> I was planning to do a better solution, but I didn't have the time, yet.
> Can you _please_ either:
> - Wait for my ack before you apply random b43 patches
> or
> - Remove me from MAINTAINERS
> 

And there's no reason to rush this fix into mainline. We currently do not even
have a supported device which would require this fix. The Wii, which uses the SDIO bus,
does not require this fix. So the only supported device (as of now) does not need the fix
to work properly.
So it can as well go into the next merge window.

-- 
Greetings, Michael.

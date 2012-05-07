Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34252 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757683Ab2EGVXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 17:23:09 -0400
Message-ID: <1336425731.5970.124.camel@aeonflux> (sfid-20120507_232316_153494_54203E9F)
Subject: Re: [PATCH] Bluetooth: Fix coding style
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: dh.herrmann@googlemail.com, gustavo@padovan.org,
	linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Mon, 07 May 2012 14:22:11 -0700
In-Reply-To: <20120507.135547.704675228233645115.davem@davemloft.net>
References: <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
	 <20120506.145304.1998242927519675381.davem@davemloft.net>
	 <1336410360.5970.103.camel@aeonflux>
	 <20120507.135547.704675228233645115.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

> > When it comes to function declaration and function calls, the style in
> > mm/memory.c is mixed. We can start counting, but for both other
> > multi-line cases it seems that tab-only indentation is predominant.
> 
> Fair enough.
> 
> But you know what the real issue is?
> 
> I have told the bluetooth folks this matters to me, repeatedly.
> 
> And then when I pushback when some unacceptable changes slip through,
> they put a bullseye on my head and say I'm being unreasonable.
> 
> What's unreasonable about a maintainer telling you multiple times
> to do things a certain way and then getting mad when you still
> don't listen?

I have no problem in getting these fixed and you actually imposing this
coding style on all networking subsystem. That is your prerogative.

However I do have a problem if this is not documented in CodingStyle or
somewhere else as part of the kernel source. It should be documented and
people pointing out the lack of this are full in their right to do so. I
personally would expect the maintainer enforcing this rule to ensure
that it is properly documented. Especially after such a confusion has
arisen.

That checkpatch.pl needs an extra command line called --subjective or
-strict to have this easily tested is really not intuitive. I would love
to see the idea realized that checkpatch.pl does the enabling/disabling
of coding style warnings automatically based on the path.

Anyway, these are my view points on this.

Regards

Marcel



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:17493 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbXGZVTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 17:19:44 -0400
Received: by ug-out-1314.google.com with SMTP id j3so601818ugf
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 14:19:43 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Date: Thu, 26 Jul 2007 23:22:43 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200707252249.47931.IvDoorn@gmail.com> <20070726021939.GA3810@tuxdriver.com>
In-Reply-To: <20070726021939.GA3810@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707262322.43150.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Today a very quick release of 2.0.4,
> > reason for this quick followup on 2.0.3 are the fixes
> > regarding the USB ID and the rt61pci interrupts.
> 
> Ivo,
> 
> Thanks for the post -- I merged them into wireless-dev.  You might
> also notice that I moved the driver files up two levels into
> drivers/net/wireless (along w/ the other drivers).

Thanks.
But one request, do you mind if I put all rt2x00 files into
a new folder drivers/net/wireless/rt2x00 ?
There are 25 files that belong to rt2x00 and it would be nice
if I can have them grouped together.

> Any idea when you'll be ready for rt2x00 to go upstream?

Not really sure I want to have at least atop making the
suspend/resume result into a big kernel panic, and adhoc
mode should come back to live.
All other reported bugs are more rare and appear not affect
that many people.
So hopefully within 1 or 2 months should rt2x00 reach a condition
where I am more confident about moving a bit further upstream.

Ivo

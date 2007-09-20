Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:64562 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbXITOPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 10:15:02 -0400
Received: by py-out-1112.google.com with SMTP id u77so976643pyb
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2007 07:15:01 -0700 (PDT)
Message-ID: <43e72e890709200715s53e4e172j53867117147a8174@mail.gmail.com>
Date: Thu, 20 Sep 2007 10:15:01 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Forest Bond" <forest@alittletooquiet.net>
Subject: Re: VT6656 driver source available from VIA
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070920141006.GH14127@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070919193743.GA14127@storm.local.network>
	 <1190297065.18521.61.camel@johannes.berg>
	 <20070920141006.GH14127@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/20/07, Forest Bond <forest@alittletooquiet.net> wrote:
> Hi,
>
> On Thu, Sep 20, 2007 at 04:04:25PM +0200, Johannes Berg wrote:
> > On Wed, 2007-09-19 at 15:37 -0400, Forest Bond wrote:
> >
> > > This doesn't sound very GPL to me, however, the twist is in main_usb.c:
> >
> > Not really.
> >
> > > MODULE_LICENSE("GPL");
> >
> > > What do you think?
> >
> > That declaring MODULE_LICENSE in a file that isn't licensed under GPL is
> > a violation of the kernel license.
>
> And, assuming that in-kernel support for this chip is desirable, is it better to
> pursue license clarification from VIA, or re-implement using the driver source
> as a reference?
>
> The reason I ask is that I suspect for this driver to get into the kernel, it
> will likely see a lot of changes, anyway.  If it's going to be rewritten,
> there's little sense in me pushing VIA on the license issue, is there?
>
> I hope I'm not being daft.

Try to get license clarification. CC John, it may help. Most vendor
drivers suck so usually they are rewritten anyway. I am not sure if we
can use it as a reference. I'm trying to find out ;) but in the mean
time try to get license clarification, it would help.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:49394 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbXIXRvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 13:51:16 -0400
Received: by py-out-1112.google.com with SMTP id u77so3044728pyb
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2007 10:51:14 -0700 (PDT)
Message-ID: <43e72e890709241051k42bb248ue0cba02e96310c1b@mail.gmail.com>
Date: Mon, 24 Sep 2007 13:51:13 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 1/2 try 2] Net: ath5k, split hw into hw, phy and initvals
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, mickflemm@gmail.com
In-Reply-To: <20070924173607.GA652@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <3175698652466923884@pripojeni.net>
	 <43e72e890709241024pd364c31k4a41c030f192cf0d@mail.gmail.com>
	 <1190654876.18521.276.camel@johannes.berg>
	 <20070924173607.GA652@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/24/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Sep 24, 2007 at 07:27:56PM +0200, Johannes Berg wrote:
> > On Mon, 2007-09-24 at 13:24 -0400, Luis R. Rodriguez wrote:
> >
> > > * ath5k_hw_set_rfgain_opt() is defined once and used once, can we
> > > instead make it inline? If we really are not going to re-use this
> > > later why do we put it into a routine on its own?
> >
> > Why mark it inline then? The compiler will inline it anyway if it's only
> > used once. And I haven't looked at the code but making it an own routine
> > could possibly make the code more readable, especially if lots of
> > indentation is involved.`
>
> Seconded.  Splitting things up into logically sound subroutines is
> good programming style.

Then that comment can be ignored, thanks.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27694 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751239Ab0IOHcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 03:32:36 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0200975953
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 16:32:34 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: [ath5k-devel] [ath5k] Incorrect value for ACK_TIMEOUT
Date: Wed, 15 Sep 2010 16:32:46 +0900
Cc: Kalle Valo <kvalo@adurom.com>, ath5k-devel@lists.ath5k.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mickflemm@gmail.com>
References: <AANLkTim+Q773KvA7Et1s2Zf8yMx36RGS2LsoJsX1Wtt9@mail.gmail.com> <871v8v5vd2.fsf@purkki.adurom.net> <AANLkTinD+y+CvxijXvxfqB9ncWdD0qYLi-e0PRvczwem@mail.gmail.com>
In-Reply-To: <AANLkTinD+y+CvxijXvxfqB9ncWdD0qYLi-e0PRvczwem@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009151632.46340.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed September 15 2010 16:27:01 Jonathan Guerin wrote:
> So, we would prefer to match the spec for an out-of-the-box build,
> even tho it would appear to be a worse-performing driving to users?

sure, we need to comply to the specs.

bruno

> --
> Jonathan Guerin
> 
> On Wed, Sep 15, 2010 at 5:17 PM, Kalle Valo <kvalo@adurom.com> wrote:
> > Jonathan Guerin <jonathan@guerin.id.au> writes:
> >>> the thing is, like bob said, that we don't really know much about what
> >>> the HW expects in some of these registers, so unless you can prove
> >>> your changes to be correct - e.g. by measurements which fit the
> >>> theoretical model better, or by better thruput, it's hard to say if
> >>> they are correct or not.
> >>> 
> >>> so before you worry about how to make a correct patch, just go ahead
> >>> and change those initvals to what you believe they should be. if it
> >>> improves something, let's talk about how to correctly fix it.
> >> 
> >> I don't mean to be a smart-ass, but wouldn't setting the correct
> >> values here decrease the throughput? I'm not quite sure how to verify
> >> an improvement, other than get the card to contend for the medium with
> >> another known-working card? Does this sound reasonable?
> > 
> > Yes, it does sound reasonable. You might get throughput increase by
> > violating the spec.
> > 
> > --
> > Kalle Valo

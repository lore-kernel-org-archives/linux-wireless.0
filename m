Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2206 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0HBUIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:08:49 -0400
Subject: Re: [PATCH 3/3] compat: define struct va_format introduced in
 v2.6.36
From: Joe Perches <joe@perches.com>
To: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C57227A.1050802@gmail.com>
References: <4C55D22A.5040302@hauke-m.de>
	 <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com>
	 <AANLkTinfrBRm8J2G+k8bB6N-YniVkmUYOBkRpyF_tC2j@mail.gmail.com>
	 <4C571F0B.3000200@gmail.com> <1280778534.1752.68.camel@Joe-Laptop.home>
	 <4C57227A.1050802@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 13:08:47 -0700
Message-ID: <1280779727.1752.71.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-02 at 21:54 +0200, Kshitij Kulshreshtha wrote:
> As on 2010-08-02 21:48, Joe Perches did write:
> > On Mon, 2010-08-02 at 21:39 +0200, Kshitij Kulshreshtha wrote:
> >> As on 2010-08-02 20:00, Luis R. Rodriguez did write:
> >>> On Sun, Aug 1, 2010 at 3:02 PM, Kshitij Kulshreshtha
> >>>> +struct va_format {
> >>>> +       const char *fmt;
> >>>> +       va_list *va;
> >>>> +};
> >>> I'll apply this for now but what caller uses this for example?
> > Why is this necessary?
> I needed this to compile compat-wireless which is based on linux-next.
> Otherwise net/wireless/core.c fails to compile, due to the use of this
> struct va_format in the functions defined in lines 910--958. If this
> usage is reverted, we won't need it in compat.

I see your problem.

I think your problem should not be a constraint
on new development and I do not think the new use
should be reverted.

cheers, Joe


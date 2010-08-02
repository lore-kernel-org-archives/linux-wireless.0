Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2203 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0HBTs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 15:48:57 -0400
Subject: Re: [PATCH 3/3] compat: define struct va_format introduced in
 v2.6.36
From: Joe Perches <joe@perches.com>
To: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C571F0B.3000200@gmail.com>
References: <4C55D22A.5040302@hauke-m.de>
	 <1280700173-14690-4-git-send-email-kkhere.geo@gmail.com>
	 <AANLkTinfrBRm8J2G+k8bB6N-YniVkmUYOBkRpyF_tC2j@mail.gmail.com>
	 <4C571F0B.3000200@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 12:48:54 -0700
Message-ID: <1280778534.1752.68.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-02 at 21:39 +0200, Kshitij Kulshreshtha wrote:
> As on 2010-08-02 20:00, Luis R. Rodriguez did write:
> > On Sun, Aug 1, 2010 at 3:02 PM, Kshitij Kulshreshtha
> >> +struct va_format {
> >> +       const char *fmt;
> >> +       va_list *va;
> >> +};
> > I'll apply this for now but what caller uses this for example?

Why is this necessary?


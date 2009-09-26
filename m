Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:38900 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZIZCOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 22:14:18 -0400
Received: by iwn10 with SMTP id 10so1849730iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 19:14:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909260350.07465.malte.gell@gmx.de>
References: <200909242155.19485.malte.gell@gmx.de> <200909251132.18546.malte.gell@gmx.de>
	<4ABD2504.9010202@gmx.de> <200909260350.07465.malte.gell@gmx.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 25 Sep 2009 19:14:02 -0700
Message-ID: <43e72e890909251914i465e10c8jc257c904260dec6c@mail.gmail.com>
Subject: Re: ar9170 makes machine hang when shut down
To: Malte Gell <malte.gell@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 6:50 PM, Malte Gell <malte.gell@gmx.de> wrote:
>
> openSUSE 11.1 runs a 2.6.27 kernel, doesn't ar9170 need a 2.6.29 kernel?
> Somehow SUSE manages it in their packages, so I used the SUSE source rpm, but
> of course compat-wirless is more recent, but I can't compile it...

Then upgrade your kernel, send patches to add compat-wireless support
for the needed stuff on 2.6.27, or wait.

  Luis

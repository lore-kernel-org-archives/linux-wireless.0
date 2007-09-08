Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:25121 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbXIHQF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 12:05:26 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1220532mue
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 09:05:24 -0700 (PDT)
To: "Rob Hussey" <robjhussey@gmail.com>
Subject: Re: Kernel panic with rt2500pci built-in
Date: Sat, 8 Sep 2007 18:16:10 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com> <1189244217.4506.16.camel@johannes.berg> <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
In-Reply-To: <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709081816.10143.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 September 2007, Rob Hussey wrote:
> On 9/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > ?! That shouldn't have an effect like that. Are you positive that you
> > put the register_hw call back?
> 
> Yeah, I thought the same thing, so I even did a git-reset --hard HEAD
> and double-checked rt2x00dev.c to make sure everything was back to
> normal before editing core.c again.

And there was no rt2x00lib, rt2x00pci or rt2500pci error message
in the log that could indicate why the device is not present?
Could you compile rt2x00 with debug enabled and see what additional
messages are being printed out?

Ivo

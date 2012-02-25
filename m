Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37435 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2BYClU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 21:41:20 -0500
Received: by iazz13 with SMTP id z13so853074iaz.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 18:41:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330136920-15954-1-git-send-email-sidhayn@gmail.com>
References: <1330136920-15954-1-git-send-email-sidhayn@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 24 Feb 2012 18:41:00 -0800
Message-ID: <CAB=NE6Vpch++VKPCofdML0wk9f+BLquwutdJhHN2nSCn8R6JFw@mail.gmail.com> (sfid-20120225_034125_103329_60351504)
Subject: Re: [PATCH]v5 compat-wireless: replace modprobe -l with functional equivilent
To: Rick Farina <sidhayn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 24, 2012 at 6:28 PM, Rick Farina <sidhayn@gmail.com> wrote:
> modprobe -l is either deprecated or removed, so let's replace it
> testing [ -z "$(DESTDIR)" ] appeared to only be need due to the fact
> that *enable was run directly instead of being run with $(DESTDIR)/
>
> Testing for module presence should now work properly on modern distros
> and *enable will be run properly with or without $(DESTDIR) being set.
>
> Signed-off-by: Rick Farina <sidhayn@gmail.com>

Applied and pushed, thanks!

  Luis

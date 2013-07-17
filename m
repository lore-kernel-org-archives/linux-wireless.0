Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41749 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3GQRm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jul 2013 13:42:27 -0400
Received: by mail-wi0-f178.google.com with SMTP id k10so2284459wiv.5
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jul 2013 10:42:25 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Jul 2013 10:42:25 -0700
Message-ID: <CAJ-Vmo=yvHUgv6pwK42n+NhPrAu9shxc5pigRkhZE+x91W_FoA@mail.gmail.com> (sfid-20130717_194238_629152_551DCEC6)
Subject: So, which IEEE<->Frequency mappings should we be all using?
From: Adrian Chadd <adrian@freebsd.org>
To: freebsd-wireless@freebsd.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I've been increasingly asked to bring up FreeBSD on "other" bands.

* 420MHz
* 700MHz
* 900MHz (which we already have, due to history);
* 3.6GHz
* 4.9GHz

I'd also like to support half and quarter width channels on these
frequencies. If I use the 2GHz channel mapping method, I end up with a
very restricted channel set and it definitely has no "gaps" for
5/10MHz increments.

Now, what I'd like to do is figure out some sane, shared method of
translating channel frequencies to IEEE numbers and back. That way the
BSDs and Linux (and maybe commercial stacks; I dunno what they do) can
have some sane chance of interoperating.

So: Is there some standardised or semi-standardised channel mapping
method? Or should we invent one?


-adrian

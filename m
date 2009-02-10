Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10116 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZBJSUA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 13:20:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 10:20:00 -0800
Date: Tue, 10 Feb 2009 10:19:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Lurkos <lurkos.usenet@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Merge compat-wireless-old into 2.6.26
Message-ID: <20090210181915.GA4248@tesla> (sfid-20090210_192007_189243_5583291B)
References: <20090210172817.9004.60065.XPN@L622132.user.x-privat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090210172817.9004.60065.XPN@L622132.user.x-privat.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 10, 2009 at 09:28:16AM -0800, Lurkos wrote:
> Is it possibile to patch linux 2.6.26 source (e.g. Debian Lenny sources)
> to have the new compat-wireless-old?
> If yes, what could be the correct procedure?

It is possible, you would just have to replace the directories
that compat-wireless-old has in the kernel sources.

> I would prefer to compile only my wireless network card driver
> statically into the kernel.

What exactly will that buy you though? Is it worth the effort?

  Luis

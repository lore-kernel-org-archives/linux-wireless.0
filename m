Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45010 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbZLJUyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 15:54:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Natale Vinto <ebballon@gmail.com>
Subject: Re: SIOCSIFFLAGS: Name not unique on network with b43
Date: Thu, 10 Dec 2009 21:54:03 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6e9632c0912091546gad933ffhe8b70ee889745cb1@mail.gmail.com> <200912101603.38843.mb@bu3sch.de> <c6e9632c0912101250n638f7046w2447d96a946f01b0@mail.gmail.com>
In-Reply-To: <c6e9632c0912101250n638f7046w2447d96a946f01b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912102154.04748.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 December 2009 21:50:57 Natale Vinto wrote:
> > So the next step is to read that error message. It tells you exactly what's
> > going on: Operation not supported
> :-)
> 
> But why in the Driver page there is written that b43 works with
> multiple interfaces? This means that I can create for example two
> interfaces but I can't use both?

You can use multiple monitor interfaces simultaneously with a sta or ap interface.

-- 
Greetings, Michael.

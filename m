Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45566 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZLJPDe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 10:03:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Natale Vinto <ebballon@gmail.com>
Subject: Re: SIOCSIFFLAGS: Name not unique on network with b43
Date: Thu, 10 Dec 2009 16:03:37 +0100
Cc: linux-wireless@vger.kernel.org
References: <c6e9632c0912091546gad933ffhe8b70ee889745cb1@mail.gmail.com> <4B204204.6000300@erley.org> <c6e9632c0912091712x6f0e0bfboc8fa2c0ad32e5b80@mail.gmail.com>
In-Reply-To: <c6e9632c0912091712x6f0e0bfboc8fa2c0ad32e5b80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912101603.38843.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 December 2009 02:12:37 Natale Vinto wrote:
> Hi,
> I've changed the mac of the AP interface for example, using
> macchanger. Then I've created a managed wlan1 one but now I got:
> SIOCSIFFLAGS: Operation not supported

So the next step is to read that error message. It tells you exactly what's
going on: Operation not supported

-- 
Greetings, Michael.

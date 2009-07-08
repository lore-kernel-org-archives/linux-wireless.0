Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:41469 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbZGHHc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 03:32:29 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: BUG REPORT: libertas causing kernel lockups
Date: Wed, 8 Jul 2009 09:32:17 +0200
Cc: Alexander Barinov <alex.barinov@gmail.com>
References: <20090704130346.01b2e869@dream> <200907070859.39413.hs4233@mail.mn-solutions.de> <20090708003734.0d57b389@dream>
In-Reply-To: <20090708003734.0d57b389@dream>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907080932.17728.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sorry for asking a potentially stupid question as I am no way
> a wireless hardware expert, but can this bug be caused by
> wrong firmware version?

AFAIK not.

> BTW, it is really hard to find a patch you are talking about
> in the archive. 

It's dead easy:

$ cd linux-git
$ git show 87057825824973f29cf2f37cff1e549170b2d7e6

Or you can go via the web-interface: start at 
http://git.kernel.org, search Linus' tree and you end up at 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary.

Now select any commitdiff, and substitute in the URL the 
hex-thingy from above. And voila, you're at

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=87057825824973f29cf2f37cff1e549170b2d7e6


-- 
http://www.holgerschurig.de

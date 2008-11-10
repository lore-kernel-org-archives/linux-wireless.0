Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44102 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbYKJR5s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 12:57:48 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 09:57:48 -0800
Date: Mon, 10 Nov 2008 09:57:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: msan <msan@email.it>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: problems with ath5k driver.
Message-ID: <20081110175746.GC6918@tesla> (sfid-20081110_185809_179394_E3A893FF)
References: <geiib4$apo$2@ger.gmane.org> <20081103191625.4rwqio60gsgs0gso-cebfxv@webmail.spamcop.net> <get27e$ka2$1@ger.gmane.org> <43e72e890811051322m43efbf03gd21770be382e807d@mail.gmail.com> <1225989658.4276.4.camel@dv> <gf3rag$l51$1@ger.gmane.org> <1226142085.3610.4.camel@johannes.berg> <gf3s12$l51$2@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <gf3s12$l51$2@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 08, 2008 at 03:09:22AM -0800, msan wrote:
> Il Sat, 08 Nov 2008 12:01:25 +0100, Johannes Berg ha scritto:
> 
> >> If I can say, the card now works perfectly but is rather slow. I am
> >> downloading some files from another computer inside my lan at home, not
> >> from internet.
> >> The other computer is connected with an ethernet card while my computer
> >> is connected with my wireless card, ATheros. The download starts at 1Mb
> >> and more but quickly degrades at 200 - 170 kb. it.
> >> Perhaps the driver needs some work yet.
> >
> > Which RC algorithm are you using? Use minstrel if you can.
> 
> Sorry for my ignorance but....where I can set the algorithm that I must
> use?

make menuconfig on the kernel

  Luis

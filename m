Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:58612 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0CVQhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 12:37:48 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1237371qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 09:37:47 -0700 (PDT)
From: Steven Wheeler <stevenwheel@gmail.com>
To: "'Christian Lamparter'" <chunkeey@googlemail.com>
Cc: "'Pavel Roskin'" <proski@gnu.org>, <linux-wireless@vger.kernel.org>
References: <002a01cac969$b726e8d0$2574ba70$@com> <1269232531.18891.6.camel@mj> <000001cac99b$cf9ff140$6edfd3c0$@com> <201003221647.43357.chunkeey@googlemail.com>
In-Reply-To: <201003221647.43357.chunkeey@googlemail.com>
Subject: RE: Problems with Netgear WG511v1 PCMCIA
Date: Mon, 22 Mar 2010 11:37:44 -0500
Message-ID: <000001cac9de$00a868c0$01f93a40$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interesting, this link is broken too, but only for IE (I am using my desktop
right now)
I re-installed FireFox (long story behind that) and it works just fine.

OK, from the pictures it appears to be the WG511 V2 or V3, the front and
back labeling matches the label positions in the V3 pic
But, an lspci shows that it has the isl3890 chipset

I just downloaded the latest kernel (2.6.33.1), will build this afternoon
I already have the P%$ firmware for kernels above 2.6.28, so I can test
Will update later

Thank you very much

-----Original Message-----
From: Christian Lamparter [mailto:chunkeey@googlemail.com] 
Sent: Monday, March 22, 2010 10:48 AM
To: Steven Wheeler
Cc: 'Pavel Roskin'; linux-wireless@vger.kernel.org
Subject: Re: Problems with Netgear WG511v1 PCMCIA

On Monday 22 March 2010 09:43:55 Steven Wheeler wrote:
> Sorry, meant to include it: Kernel is 2.6.27.7
that's ancient.

you should give compat-wireless a try:
http://linuxwireless.org/en/users/Download
and keep your finger crossed...

> I thought about trying the prism54 driver but was unable to download the
> firmware from the links in the P54 site.
> No matter what I did I kept getting the html page back as a text file to
be
> saved, very weird.

First things first, are you really sure you got an WG511v1 and not the
v1.02?
Take a look at: http://daemonizer.de/prism54/wg511/ there you'll see
several pictures of different WG511 versions.

I can give you a working link, but first I need to know if this is a genuine
v1.

Regards,
	Chr


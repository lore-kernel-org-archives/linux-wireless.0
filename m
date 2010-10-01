Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34137 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0JAO3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 10:29:36 -0400
Received: by wyb28 with SMTP id 28so2964371wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 07:29:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
From: Saqeb Akhter <saqeb.akhter@gmail.com>
Date: Fri, 1 Oct 2010 10:22:45 -0400
Message-ID: <AANLkTinpJ2qzR3D6Oe1WOS60sfRergfH548EMdB2m=_P@mail.gmail.com>
Subject: carl9170: wnda3100 only 54MB/s
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Guys,

I just got around to compiling compat-wireless on ubuntu 10.04, to
make use of the new carl9170 driver which is supposed to be able to
handle 802.11n.

My router is a wndr3700 running @ 5ghz on windows I'm able to get
pretty good speeds. But on Ubuntu it does not seem to connect faster
than 54MB/s, iwlist scan shows that 54Mb/s is the highest it can go.

Is there something special that needs to be done or enabled to let the
wnda3100 know it can go faster, or is this a bug or is 54MB/s the
fastest the driver can go right now?

Wireless Adapter: WNDA3100
Wireless Router: WNDR3700

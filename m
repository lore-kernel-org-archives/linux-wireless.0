Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34790 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0IRUSJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 16:18:09 -0400
Received: by wyf22 with SMTP id 22so3294260wyf.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Sep 2010 13:18:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=SL_tCO4k071KZxawch90NqdnGFMaqy_uqPTHA@mail.gmail.com>
References: <AANLkTi=1NaRKc8QrQBGwU+c_17D86_Cqu9MopR_rso0H@mail.gmail.com>
	<AANLkTin3qXSbuWejTGJzz6cO6fycK4HqU4gn4gF1wEdp@mail.gmail.com>
	<4C6422FB.8040204@lwfinger.net>
	<AANLkTikPm64cko+wricospR-Y0KNAB0JevBGQ0iLc_02@mail.gmail.com>
	<AANLkTi=SL_tCO4k071KZxawch90NqdnGFMaqy_uqPTHA@mail.gmail.com>
Date: Sat, 18 Sep 2010 13:18:08 -0700
Message-ID: <AANLkTikCnJGhFN+cKc6aMi-hwLGbZ3C_J4brGp_jC7gq@mail.gmail.com>
Subject: Re: Hi,Linus Torvalds. There's a problem in r8192u driver in Linux
 new kernel.
From: Paul Thomas <pthomas8589@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gauss Frank <gaussfrank@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jerry chuang <wlanfae@realtek.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It is not in the main tree until 2.6.37. You can get it from my r8712u tree
> at kernel.org, or from the linux-next tree.

Yeah, that works! This is great because most of the "mini" wifi cards
use the rtl8188su. This is on an Atmel at91sam9g20 arm processor, it
only has 12Mbps USB. I haven't tested wpa yet.

thanks,
Paul

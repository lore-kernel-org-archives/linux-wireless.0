Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:42310 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbbBZTCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 14:02:04 -0500
Date: Thu, 26 Feb 2015 20:01:57 +0100
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Sergei Antonov <saproj@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mt7601u dies during channel switch (was: MediaTek WiFi hardware
 support in upstream kernel)
Message-ID: <20150226200157.2f8162fb@north> (sfid-20150226_200220_597952_5D2A923E)
In-Reply-To: <CABikg9xRG2WBvLPzG-W4tOXpWyRYhZ_sJdZ7h8vE=hELochREg@mail.gmail.com>
References: <544DB5A8.7090405@openmailbox.org>
	<20141027152026.GB19976@tuxdriver.com>
	<544E8CB4.3000607@rempel-privat.de>
	<20141028134608.GA26283@tuxdriver.com>
	<544FA303.5060303@broadcom.com>
	<544FA627.3000004@rempel-privat.de>
	<5450BEB2.60208@openwrt.org>
	<5461F937.9060004@rempel-privat.de>
	<5463CB6C.3030204@openwrt.org>
	<5463D28F.9080106@lwfinger.net>
	<20150206182915.7467bac7@north>
	<CABikg9yw8Py59KyJ1mP6bfCrMPuup7v9xb1J=_JKC4gT_GS4rA@mail.gmail.com>
	<20150225103311.436f4321@north>
	<CABikg9xU+vj_W+TF4d7=x52u8abhkXC0qPGsOgRUMXDhRA0NFQ@mail.gmail.com>
	<20150226170522.01605ac4@north>
	<CABikg9xRG2WBvLPzG-W4tOXpWyRYhZ_sJdZ7h8vE=hELochREg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 26 Feb 2015 19:50:04 +0100, Sergei Antonov wrote:
> Jakub, I'll do all of it, but for now just one quick question: what
> firmware binary blob should I use with your driver? Maybe I just took
> a wrong firmware... You can send me yours.

I have the one from vendor package.  The MD5 sum is

# md5sum /usr/lib/firmware/mt7601u.bin 
696cedb8e76ecc0cda9f9b0d3972c64d  /usr/lib/firmware/mt7601u.bin

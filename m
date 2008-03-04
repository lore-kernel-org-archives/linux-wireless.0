Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55508 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbYCDTsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 14:48:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ahmed Ammar" <b33fc0d3@gmail.com>
Subject: Re: B43 will not associate
Date: Tue, 4 Mar 2008 20:47:35 +0100
Cc: linux-wireless@vger.kernel.org
References: <84ac67910803041143y76e378c7m2fd88a26115f0ae2@mail.gmail.com>
In-Reply-To: <84ac67910803041143y76e378c7m2fd88a26115f0ae2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803042047.35710.mb@bu3sch.de> (sfid-20080304_194838_889589_89F8370F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 March 2008 20:43:12 Ahmed Ammar wrote:
> b43 driver will never associate to my AP.

You are wrong:

wlan0: Initial auth_alg=1
wlan0: authenticate with AP 00:90:d0:f2:ad:7b
wlan0: RX authentication from 00:90:d0:f2:ad:7b (alg=1 transaction=2 status=0)
wlan0: replying to auth challenge
wlan0: RX authentication from 00:90:d0:f2:ad:7b (alg=1 transaction=4 status=0)
wlan0: authenticated
wlan0: associate with AP 00:90:d0:f2:ad:7b
wlan0: RX AssocResp from 00:90:d0:f2:ad:7b (capab=0x411 status=0 aid=1)
wlan0: associated

> below is the full dmesg 
> output. Also attached is the wireless capture from another card.

Can you try disabling bonding? It seems to have problems:

bonding: bond0: link status definitely up for interface wlan0.
bonding: bond0: Interface wlan0 is already enslaved!

-- 
Greetings Michael.

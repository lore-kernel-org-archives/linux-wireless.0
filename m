Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:52350 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800AbbBIJBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 04:01:32 -0500
Date: Mon, 9 Feb 2015 09:54:48 +0100
From: Jakub Kicinski <moorray@wp.pl>
To: "Simon Raffeiner (SCC)" <simon.raffeiner@kit.edu>
Cc: <linux-wireless@vger.kernel.org>, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] Ralink RT5390/RT5370 no longer works on more
 recent kernels
Message-ID: <20150209095448.21fe1774@north> (sfid-20150209_100138_615509_1DC44B8C)
In-Reply-To: <54D64337.7080005@kit.edu>
References: <54D64337.7080005@kit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Simon,

On Sat, 7 Feb 2015 17:54:15 +0100, Simon Raffeiner (SCC) wrote:
> Hello everyone,
> 
> one of my USB wireless adapters, based on the Ralink RT5390/RT5370
> chipset and RF, no longer works on more recent kernels. It doesn't
> report any networks on "iw dev wlan0 scan" and doesn't associate if told
> to do so.

I tested a TP-Link TL-727N v3.2 which also is:

RT chipset 5390, rev 0502 detected
RF chipset 5370 detected

and it works fine on 3.19-rc5 (from the wireless-testing tree).

Are you testing the different kernels on the same machine?  
Can you try bisection?


kuba

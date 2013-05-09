Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56174 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3EIE0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 00:26:55 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20875.9473.525821.266607@gargle.gargle.HOWL> (sfid-20130509_062658_883639_DEA0F9DD)
Date: Thu, 9 May 2013 09:54:33 +0530
To: Wally <wally.yeh@a-trust.com.tw>
Cc: linux-wireless@vger.kernel.org
Subject: Re: atheros AR5B22, using ath9k, can't switch between inscure and
 WEP/WPA
In-Reply-To: <1368015905.17674.11.camel@bigdick-desktop>
References: <1368015905.17674.11.camel@bigdick-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wally wrote:
>     Recently I got a atheros mini-PCIE wifi module AR5B22, so I download
> the latest version of compat-driver(compat-drivers-2013-03-28.tar.gz),
> and build it for armel on my arm board, it works great but with one
> little problem:
> 
> If I connect to an inscure AP then change to a WEP/WPA AP, I can't
> connect the inscure one again, I have to run "modprobe -r ath9k;
> modprobe ath9k" to connect the inscure AP.
> 
>     I think this may be a bug in the ath9k driver, I also search this
> bug on web but without an answer, so I send this letter for help.

What commands do you use to connect to the APs ? Also, can you post the
kernel log / wpa_supplicant log when the issue happens ?

Sujith

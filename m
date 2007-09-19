Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from clarity.mcc.ac.uk ([130.88.200.144]:60561 "EHLO
	clarity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXISWdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 18:33:00 -0400
Message-ID: <46F19EE2.6040402@gentoo.org>
Date: Wed, 19 Sep 2007 23:12:50 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: davem@davemloft.net, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
Subject: Re: Please pull 'z1211' branch of wireless-2.6
References: <20070919181005.GB5483@tuxdriver.com>
In-Reply-To: <20070919181005.GB5483@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Jeff & Dave,
> 
> This patch adds z1211 (previously known as zd1211rw-mac80211),
> a driver for Zydas ZD1211 hardware.  This driver has proven very
> robust -- Fedora 7 uses this driver and I don't think I have any open
> bugzillas for it.  

BTW: I fairly regularly get email from F7 users complaining about 
connection intermittancy and other bugs that we don't seem to have for 
the softmac driver (maybe stack related issues, of which I've fixed a 
couple that affected me personally, I'm a little surprised that F7 
jumped so early).

I've been suggesting that such users move to zd1211rw-softmac until both 
Ulrich and myself are happy and we've made the jump upstream.

Daniel

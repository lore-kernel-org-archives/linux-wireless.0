Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ted.prima.de ([83.97.48.3]:56109 "EHLO ted.prima.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbZJLSFe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 14:05:34 -0400
Message-ID: <4AD36F67.2090107@penny.prima.de>
Date: Mon, 12 Oct 2009 20:03:19 +0200
From: Riffer <riffer@penny.prima.de>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Bleeding Edge does not compile (was Re: Bleeding Edge b43 dated
 since 30 of september no  longer working & today does not even compile.)
References: <4ACB91E7.5010405@penny.prima.de> <20091006211102.GC2911@tuxdriver.com> <4ACCDF24.7050002@penny.prima.de> <200910121309.47401.florian@openwrt.org>
In-Reply-To: <200910121309.47401.florian@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Florian Fainelli wrote:

> I got the same compilation failure here, the code in ath5k/base.c looks 
> perfectly fine though.

The problem has been fixed in "compat-wireless-2009-10-09".
This package works as good as my previous favorite for "b43" named
"compat-wireless-2009-09-16". In addition it seems to be a little more
stable regarding connecting on system startup.

Thanks to whoever has fixed that! :-)

-- 
Riffer

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:54056 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761022AbZJJNGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 09:06:22 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	netdev@vger.kernel.org
Subject: Re: Ath5k data aborts
References: <m3tyy8fkda.fsf@intrepid.localdomain>
	<40f31dec0910100356i470a93d0x3244867e1160e9df@mail.gmail.com>
Date: Sat, 10 Oct 2009 15:05:43 +0200
In-Reply-To: <40f31dec0910100356i470a93d0x3244867e1160e9df@mail.gmail.com>
	(Nick Kossifidis's message of "Sat, 10 Oct 2009 13:56:36 +0300")
Message-ID: <m363anz9eg.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis <mickflemm@gmail.com> writes:

> Interesting, can you provide us with an eeprom info dump from your
> card (using ath_info tool from madwifi svn) ?
> It seems we need to skip sleep clock operation in your case.

BTW the problem doesn't always happen immediately, sometimes it shows up
only on second or further hostapd invocation. I think in only occurs
while hostapd is starting - if it starts successfully, it works.
-- 
Krzysztof Halasa

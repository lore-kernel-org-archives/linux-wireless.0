Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50393 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaLXCuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 21:50:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Y3c1T-0001Ms-DQ
	for linux-wireless@vger.kernel.org; Wed, 24 Dec 2014 03:50:03 +0100
Received: from 095-096-207-026.static.chello.nl ([95.96.207.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2014 03:50:03 +0100
Received: from webmaster1989 by 095-096-207-026.static.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2014 03:50:03 +0100
To: linux-wireless@vger.kernel.org
From: Melroy van den Berg <webmaster1989@gmail.com>
Subject: Re: [ath9k-devel] IBSS network crashes after one device leaves network
Date: Wed, 24 Dec 2014 02:45:39 +0000 (UTC)
Message-ID: <loom.20141224T034313-122@post.gmane.org> (sfid-20141224_035031_154794_CD60864C)
References: <C7367401563A9D46BC5A92B9456C061D48D210@G08CNEXMBPEKD03.g08.fujitsu.local>	 <54455DDF.50305@rempel-privat.de> (sfid-20141020_211003_234775_62CEB57E) <1413833356.32358.4.camel@jlt4.sipsolutions.net> <5446660B.4040602@rempel-privat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@...> writes:
> hmm.. suddenly rate scaling is not singe limitation of ath9k-htc.
> Firmware keeps some information for each STA and trying to reduce usb
> bandwidth. If i understand it correctly, ath10k works in the same way.
> It means, early or soon we need to work with some hard limits.


I think it's exactly the same limit as for the AP mode.

See: https://lists.ath9k.org/pipermail/ath9k-devel/2013-April/010513.html

There should be some solution, atleast the IBSS network shouldn't crash.


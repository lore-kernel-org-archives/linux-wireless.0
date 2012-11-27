Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58409 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab2K0TQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:16:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TdQeS-0004XD-25
	for linux-wireless@vger.kernel.org; Tue, 27 Nov 2012 20:17:00 +0100
Received: from g231079119.adsl.alicedsl.de ([92.231.79.119])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 20:17:00 +0100
Received: from drahemmaps by g231079119.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 20:17:00 +0100
To: linux-wireless@vger.kernel.org
From: Martin Schleier <drahemmaps@gmx.net>
Subject: Re: [RFC 0/3] Add spectral scan support for Atheros AR92xx/AR93xx
Date: Tue, 27 Nov 2012 19:16:38 +0000 (UTC)
Message-ID: <loom.20121127T201036-82@post.gmane.org> (sfid-20121127_201654_183265_CA7D13D9)
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <simon.wunderlich@...> writes:

> This patchset is a first request for comments for the upcoming spectral
> scan feature. It adds a new attribute to nl80211 to ask for a spectral
> scan while scanning, because we cycle through the channels anyway at
> this time. If enabled by the driver, spectral scan results will be
> collected. This feature has been enabled for AR92xx and AR93xx based
> chipsets. As the FFT samples are very hardware dependent, they are only
> provided via a debugfs file for further evaluation.
> 
> [3] http://www.wehavemorefun.de/fritzbox/Ath_spectral.ko#Symbole

Erm. Just a quick question, since you mentioned this fritzbox ath_spectral.ko
module... Is your "work" based or related to it, i.e.: did you peek at the
assembler listings of it, or did someone else write a spec. and you just
implemented it? 



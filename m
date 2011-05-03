Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50963 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab1ECUkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 16:40:12 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QHMO8-0002zN-Mu
	for linux-wireless@vger.kernel.org; Tue, 03 May 2011 22:40:08 +0200
Received: from adsl-ull-186-53.48-151.net24.it ([151.48.53.186])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 22:40:08 +0200
Received: from rossi.f by adsl-ull-186-53.48-151.net24.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 22:40:08 +0200
To: linux-wireless@vger.kernel.org
From: Fabio Rossi <rossi.f@inwind.it>
Subject: Re: [RFC] mac80211: Fix a warning due to skipping tailroom reservation for IV
Date: Tue, 3 May 2011 20:34:38 +0000 (UTC)
Message-ID: <loom.20110503T223125-677@post.gmane.org> (sfid-20110503_224014_776732_0DAC6497)
References: <1304438716-18800-1-git-send-email-mshajakhan@atheros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mshajakhan@...> writes:

> 
> From: Mohammed Shafi Shajakhan <mshajakhan@...>
> 
> The devices that require IV generation in software need tailroom
> reservation  for ICVs used in TKIP or WEP encryptions.
> Currently, decision to skip the tailroom reservation in the tx
> path was taken only on whether driver wants MMIC to be generated
> in software or not. Following patch appends IV generation check for
> such decisions and fixes the following warning.

I have been testing the patch for the last two hours. I don't have
anymore WARNINGs.

Thanks,
Fabio



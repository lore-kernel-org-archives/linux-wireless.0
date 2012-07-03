Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2GCN3m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 09:29:42 -0400
Message-ID: <1341322180.20124.4.camel@jlt3.sipsolutions.net> (sfid-20120703_152946_874120_D61387F3)
Subject: Re: wlan automated tests
From: Johannes Berg <johannes@sipsolutions.net>
To: Piotr.Nakraszewicz@tieto.com
Cc: linux-wireless@vger.kernel.org, filip.matusiak@tieto.com,
	mcgrof@gmail.com, pstew@chromium.org
Date: Tue, 03 Jul 2012 15:29:40 +0200
In-Reply-To: <E50901D4F2CF69428D43141B7C85867929E154AE7B@EXMB03.eu.tieto.com> (sfid-20120703_144755_333640_EC1CCA88)
References: <E50901D4F2CF69428D43141B7C85867929E154AE7B@EXMB03.eu.tieto.com>
	 (sfid-20120703_144755_333640_EC1CCA88)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-03 at 15:47 +0300, Piotr.Nakraszewicz@tieto.com wrote:

> 1. wifi-test:
> http://wireless.kernel.org/en/developers/Testing/wifi-test
> But it looks dead. Last commit is from 2010.

This is definitely dead.

> 2. LTP:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/19759
> http://thread.gmane.org/gmane.linux.ltp/7884

I don't know about this.

> 3. Chromium Wifi tests:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/57576

But I think this is probably the best one to extend.


Just earlier today I was thinking about nl80211-based tests like "scan
with the maximum IE length advertised" etc. I guess this would be
worthwhile to add into the test suite somehow.

johannes


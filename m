Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout026.mac.com ([17.148.16.101]:50629 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab1ACSM0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jan 2011 13:12:26 -0500
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp026.mac.com (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep
 26 2008; 64bit)) with ESMTPSA id <0LEG00711L884W30@asmtp026.mac.com> for
 linux-wireless@vger.kernel.org; Mon, 03 Jan 2011 10:12:12 -0800 (PST)
Subject: Re: wl1271 status/update
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <0826983CC0CB074798C42E77D8ACD07F0616CB@pdtms1.pdt.com>
Date: Mon, 03 Jan 2011 22:11:47 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <84939413-EF08-49D3-B3F2-AEAD2DC2C1D5@mac.com>
References: <0826983CC0CB074798C42E77D8ACD07F0616CB@pdtms1.pdt.com>
To: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Jan 3, 2011, at 8:02 PM, Brzezowski, Karen wrote:

> talk has been about compat-wireless, etc..

I tried this briefly and abandoned it, because the android-2.6.32 kernel code base is
different from the run-time pm sdio patch set that's published on the wl1271 wiki site.

I managed to get the proprietary ti wilink 6.1.0.0 working with an arago-omappsp-03.00.00.05-kernel.

But for some reason, when compiling it against the android-2.6.32 (rowboat-eclair-2.6.32 kernel)
it gives some sdio related errors. I'm still working on it.

the wl1271 wlan driver in the android kernel didn't work, possibly for the same reason that the wilink-6.1.0.0
driver didn't work with the android kernel.

I mean, one would think that its already been made to work, i.e. rowboat-eclair-2.6.32 kernel + android-2.2 wl1271 driver
but that is so far from the truth.

Elvis Dowson

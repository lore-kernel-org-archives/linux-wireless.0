Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63059 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab1D2E7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 00:59:00 -0400
Received: by wya21 with SMTP id 21so2588790wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 21:58:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19898.4633.920683.992470@gargle.gargle.HOWL>
References: <19897.11321.556139.837633@gargle.gargle.HOWL>
	<201104290116.26355.chunkeey@googlemail.com>
	<19898.4633.920683.992470@gargle.gargle.HOWL>
Date: Fri, 29 Apr 2011 12:58:59 +0800
Message-ID: <BANLkTimid2tcH5nNHYkU6UPHhnxvgnJJYQ@mail.gmail.com> (sfid-20110429_065904_866365_32965179)
Subject: Re: [PATCH 1/2] ath9k_htc: Dump base eeprom header for UB91/94/95
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith <m.sujith@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 April 2011 09:19, Sujith <m.sujith@gmail.com> wrote:

> And BSD ? BSD is dead. Adrian is just deluded. :-)

I know. There's even a commit to ath9k from me that obviously indicates that. :)

But in all seriousness, I just wrote a few tools for BSD that:

* take a dump of the EEPROM via the HAL diag API and write it to a
text file, so it can be copied around as needed;
* take a text dump of an EEPROM and decode it, for v14/v4k EEPROM
formats. I'm about to do one up for the AR9287 when I drop in support
for that.



Adrian

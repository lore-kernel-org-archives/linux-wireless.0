Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38334 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab1D2AKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 20:10:52 -0400
Received: by wya21 with SMTP id 21so2493724wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 17:10:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104290116.26355.chunkeey@googlemail.com>
References: <19897.11321.556139.837633@gargle.gargle.HOWL>
	<201104290116.26355.chunkeey@googlemail.com>
Date: Fri, 29 Apr 2011 08:10:50 +0800
Message-ID: <BANLkTin4Efuyz8OYrm+1M94vi9V5sy89pA@mail.gmail.com> (sfid-20110429_021106_873341_2E003C8A)
Subject: Re: [PATCH 1/2] ath9k_htc: Dump base eeprom header for UB91/94/95
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Sujith <m.sujith@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 April 2011 07:16, Christian Lamparter <chunkeey@googlemail.com> wrote:

> If you just want to dump the eeprom, then why not with a userspace utility?
> It's pretty easy to write such a thing with libusb, furthermore it's more
> versatile and portable so the *BSD-folks are not left out!

I've written a replacement set of userspace tools in freebsd which
take a raw eeprom dump from the HAL diag API and print out a v14/v4k
eeprom dump.

It isn't pretty but it works.

There were existing tools for the earlier EEPROM formats but they
worked directly from the diag API rather than an intermediary dump
file. This way users can email me a text dump and I can check/parse it
myself.


Adrian

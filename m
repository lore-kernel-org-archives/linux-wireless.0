Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33768 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbcGTPGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 11:06:31 -0400
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"driverdev-devel@linuxdriverproject.org"
	<driverdev-devel@linuxdriverproject.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 2/3] staging/rtl8192e: use s8 instead of char
Message-ID: <74d0fd1d-8197-1e4a-1ab1-a879d6dcea4e@gmail.com> (sfid-20160720_170653_996205_3051B696)
Date: Wed, 20 Jul 2016 17:06:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> rtlwifi, but I found the older r8712u device to work fine with
> the staging/rtl8712 driver.

A replacement for "staging/rtl8712", with MAC80211 support, is
available at: https://github.com/chunkeey/rtl8192su

Also a fullmac/cfg80211 driver(r92su) is available at the
same repository.

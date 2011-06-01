Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46307 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab1FABNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 21:13:51 -0400
Received: by gwaa18 with SMTP id a18so2019702gwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 18:13:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinmPug5v=tmrP-TvAXbtJNiXU5Xng@mail.gmail.com>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
	<BANLkTik73ww-bKt+zmUonNWmGB8oLPgTWA@mail.gmail.com>
	<BANLkTinxtWs9_DCEfjivxb2ae6xhfQgG3A@mail.gmail.com>
	<BANLkTinmPug5v=tmrP-TvAXbtJNiXU5Xng@mail.gmail.com>
Date: Wed, 1 Jun 2011 09:13:49 +0800
Message-ID: <BANLkTi=R6ZTnWMhJ6N=9p2i7iUh47b_H2w@mail.gmail.com> (sfid-20110601_031354_541410_79B8D507)
Subject: Re: [RFC 00/32] ath9k: add initial support for AR9330
From: Adrian Chadd <adrian@freebsd.org>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 June 2011 09:05, Daniel Halperin <dhalperi@cs.washington.edu> wrote:

> Gotcha. I was under the impression that Atheros has historically
> marketed these (misleadingly) as '1x2' devices, e.g., see the '3x3'
> devices that have 3 antennas but only 2 chains.

Ah yes, that really confuses people (including me to begin with.)

A lot of the AR9001 series stuff is marketed (still) as 3x3 by all the
card vendors.
I've made it clear on the FreeBSD ath card support matrix that they're
2x2 devices with 3 antennas, not 3x3 devices. Same with AR9285 - 1x1,
2 antennas.


Adrian

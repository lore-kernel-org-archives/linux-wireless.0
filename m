Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52035 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1AGXL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 18:11:26 -0500
Received: by iyi12 with SMTP id 12so16204644iyi.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 15:11:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTingv5Ur6UHeZoKhfYpTUw6wGMK7ULPm7V49UfPn@mail.gmail.com>
References: <AANLkTingv5Ur6UHeZoKhfYpTUw6wGMK7ULPm7V49UfPn@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 7 Jan 2011 15:11:05 -0800
Message-ID: <AANLkTinRtNfoTOFExtmSUK+P7rmy-cjySc++7gc8e8wN@mail.gmail.com>
Subject: Re: Compat-wireless as is on ChromeOS head 2011-01-07 for ath9k
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Paul Stewart <pstew@google.com>,
	Nael Atallah <Nael.Atallah@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 7, 2011 at 2:54 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/mods/compat-wireless-2.6.36-5-spn-google-2011-01-07.tar.bz2
> sha1sum: 8cd9e5eb74292d23c511cddbf0cb2d26f0451d9a

For a release that actually compiles and is load tested:

http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.36/mods/compat-wireless-2.6.36-5-spn-chromium-kernel-2011-01-07.tar.bz2
sha1sum: 8c9ebaa0bf83404bc9f70bd7fc10ae75865cf3b2

I had forgotten to also update include/ directory.

  Luis

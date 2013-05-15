Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:46691 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759807Ab3EORbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 13:31:03 -0400
Received: by mail-qc0-f180.google.com with SMTP id a10so543719qcx.39
        for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 10:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5189E31F.2090200@rempel-privat.de>
References: <CA++BO6SfpV_7pimE=-TUcbXRX9Xgd8v69B5AQzPQ2g1b82e0FA@mail.gmail.com>
	<5189E31F.2090200@rempel-privat.de>
Date: Wed, 15 May 2013 13:31:01 -0400
Message-ID: <CA++BO6TBrzJtD2cnNmUu4j6G2c5tSq228318avuGVF4r1NeW-A@mail.gmail.com> (sfid-20130515_193109_580033_55F86F88)
Subject: Re: [ath9k-devel] ath9k_htc works poorly in 3.9
From: Corey Richardson <corey@octayn.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 8, 2013 at 1:31 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> If it is an regression, can you please do "git bisect". If you can locate
> the patch which introduced this regression, it will be great.
>

It seems to have been an intermittent problem with my WAP as well; the
PoE wasn't consistent so it kept dropping out, also taking down the
adapter with it. It does seem to be a regression, but it's so hard to
reproduce that I don't think it's worth pursuing.

Thanks!

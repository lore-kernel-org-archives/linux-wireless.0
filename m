Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:50286 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZFEFxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 01:53:08 -0400
Received: by gxk10 with SMTP id 10so2384485gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2009 22:53:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
References: <1244180502-4323-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 4 Jun 2009 22:52:49 -0700
Message-ID: <43e72e890906042252k62f85192i25355d10410776c0@mail.gmail.com>
Subject: Re: [PATCH 00/15] ath9k/mac80211/iwlwifi: rate control cleanup
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 4, 2009 at 10:41 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> ath9k's rate control code is so convoluted that it really make it
> difficult to spot bugs and fix them. Here's a bunch of cleanups for
> ath9k rate control code, and a few for mac80211. I just tested ath9k.
> Will have to test others later.

Here's the all-in-one file patch:

http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009-06-04/rate-all.patch

Testing appreciated.

  Luis

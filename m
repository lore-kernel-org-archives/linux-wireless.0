Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:56180 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbZHDBXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 21:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <24959.1249348108@turing-police.cc.vt.edu>
References: <24959.1249348108@turing-police.cc.vt.edu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 3 Aug 2009 18:23:16 -0700
Message-ID: <43e72e890908031823s6049d51cl1a0dc523fb03e6e1@mail.gmail.com>
Subject: Re: 31-rc4-mmotm0730 - cfg80211 lockdep issues
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 3, 2009 at 6:08 PM, <Valdis.Kletnieks@vt.edu> wrote:
=======================================================
> [   60.656592] [ INFO: possible circular locking dependency detected ]

> [<ffffffff814a47ef>] regulatory_hint_11d+0x2b/0x574

Thanks for the report. I've sent patches for this, they are pending merge.

  Luis

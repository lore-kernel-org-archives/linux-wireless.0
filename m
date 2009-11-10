Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:48045 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbZKJOlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 09:41:37 -0500
Received: by iwn8 with SMTP id 8so58626iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 06:41:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091110100300.GE5348@jigsaw>
References: <2da21fe50911060317v55acefdvfac01821b5f9cb0f@mail.gmail.com>
	<20091110100300.GE5348@jigsaw>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 06:41:22 -0800
Message-ID: <43e72e890911100641i69129af3vbdccdeb139a62ff9@mail.gmail.com>
Subject: Re: Getting random regulatory domains on boot-up with ath9k
To: Sebastian Kemper <sebastian_ml@gmx.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 10, 2009 at 2:03 AM, Sebastian Kemper <sebastian_ml@gmx.net> wrote:
> Davide Pesavento wrote:
>> Confirmed on wireless-testing v2.6.32-rc6-wl-41575-g5e68bfb with an
>> AR5418 card using ath9k. Also 'iw reg set <country code>' stopped
>> working. Last known working kernel is v2.6.32-rc5-wl-40584-g9b469da.
>
> I noticed this as well with ath9k on 2.6.32-rc6. Has this been fixed
> already? If not I could spend some time trying to find the patch that
> caused the regression.

This was caused by a regression of mapping a region code to an alpha2
which does not have an entry on wireless-regdb, I sent a patch to
address this on wireless-regdb.

  Luis

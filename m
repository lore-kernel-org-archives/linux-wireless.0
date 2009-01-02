Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:55237 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887AbZABTGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 14:06:12 -0500
Received: by bwz14 with SMTP id 14so20356148bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 11:06:08 -0800 (PST)
Message-ID: <da94abde0901021106l721ad722w9eb857ed41214377@mail.gmail.com> (sfid-20090102_200617_089267_9A07F4AE)
Date: Fri, 2 Jan 2009 21:06:08 +0200
From: "Kalle Valo" <kalle.valo@iki.fi>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Cc: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
	 <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 2, 2009 at 8:52 PM, Stefanik G=E1bor <netrolller.3d@gmail.c=
om> wrote:
> Probably a NOBTCOEX modparam might be a good idea - when implementing
> BT coexistence in b43, a lot of non-BT-aware cards failed to work
> because the BT GPIO line was connected to the TX preamplifier,
> breaking all TX.

It would be nice to have a common interface for this, for example
through nl80211. Lots of drivers have BT coexistence support. But this
is just an idea.

Kalle
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

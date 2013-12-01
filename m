Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:59930 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3LAA6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 19:58:30 -0500
Received: by mail-la0-f44.google.com with SMTP id ep20so7710286lab.31
        for <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 16:58:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21146.33378.141904.187743@gargle.gargle.HOWL>
References: <CAEk6gTCqKgt9zX0Xs147GYfxDw2Ex-1NkG4KZ_m_pdf1M8eDLw@mail.gmail.com>
	<21146.33378.141904.187743@gargle.gargle.HOWL>
Date: Sun, 1 Dec 2013 01:58:28 +0100
Message-ID: <CAEk6gTBS=WKfmDpzhd7istgCFnxMOpqJJnr7PUwKQ=uHeS0cdw@mail.gmail.com> (sfid-20131201_015833_121734_6A92F93C)
Subject: Re: multi-wiphy (virtual radios that can be used with multiple channels)
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>, j@w1.fi
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 1, 2013 at 1:27 AM, Sujith Manoharan <sujith@msujith.org> wrote:
> Multi Channel Concurrency is required to do this, but ath9k doesn't
> support it right now.

That would imply that HW is capable of doing this, but SW driver
components are missing (and can/will be added in the future)?

BR,
Drasko

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42619 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1BGMJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 07:09:48 -0500
Received: by iyj8 with SMTP id 8so2051092iyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Feb 2011 04:09:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 7 Feb 2011 14:09:28 +0200
Message-ID: <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
To: juuso.oikarinen@nokia.com
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 7, 2011 at 1:30 PM, <juuso.oikarinen@nokia.com> wrote:
>
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>
> Currently the wl12xx interrupts are not configured to wake up the host, which
> leads to reduced performance.

Can you elaborate what do you mean ?

Today the chip is powered off at system suspend, so it won't trigger
any interrupts anyway.

When additional suspend modes will be introduced (e.g. WoWL) this will
be needed of course.

Thanks,
Ohad.

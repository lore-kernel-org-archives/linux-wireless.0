Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:22924 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283AbZABSwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 13:52:51 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2306973fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 10:52:49 -0800 (PST)
Message-ID: <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com> (sfid-20090102_195255_556900_750F1473)
Date: Fri, 2 Jan 2009 19:52:49 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Vasanthakumar Thiagarajan" <vasanth@atheros.com>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 2, 2009 at 11:05 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath9k/ath9k.h |    5 +++++
>  drivers/net/wireless/ath9k/hw.c    |   33 +++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath9k/main.c  |    9 +++++++--
>  drivers/net/wireless/ath9k/reg.h   |   10 ++++++++++
>  4 files changed, 55 insertions(+), 2 deletions(-)
>
> <snip>

Probably a NOBTCOEX modparam might be a good idea - when implementing
BT coexistence in b43, a lot of non-BT-aware cards failed to work
because the BT GPIO line was connected to the TX preamplifier,
breaking all TX.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

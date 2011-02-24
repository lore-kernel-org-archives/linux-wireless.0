Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50425 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab1BXXk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 18:40:28 -0500
MIME-Version: 1.0
In-Reply-To: <1298107341-9894-1-git-send-email-vasanth@atheros.com>
References: <1298107341-9894-1-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Feb 2011 15:40:08 -0800
Message-ID: <AANLkTikv_5vLn1WLzar1-nCmw0Sbrmm4S9_F529vEX44@mail.gmail.com>
Subject: Re: [PATCH] compat: Define usleep_range(min, max) as msleep(max/1000)
 for <2.6.36
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 19, 2011 at 1:22 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> ops_flush() of ath9k uses usleep_range().
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Thanks, applied and pushed!

  Luis

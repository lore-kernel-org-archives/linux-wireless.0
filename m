Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:52873 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0AHFWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 00:22:46 -0500
Received: by iwn32 with SMTP id 32so2894815iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 21:22:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19270.48449.16627.61097@gargle.gargle.HOWL>
References: <19270.48449.16627.61097@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Jan 2010 21:22:26 -0800
Message-ID: <43e72e891001072122v169dd2bcyea5566ce3c9d1bb8@mail.gmail.com>
Subject: Re: [PATCH 5/7] ath9k: Fix queue handling
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2010 at 9:06 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> The TX queues have to be stopped during an
> internal reset. Not handling this would result
> in packet loss - fix this.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Cc stable?

  Luis

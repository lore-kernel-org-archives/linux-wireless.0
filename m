Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:62510 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0AHF1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 00:27:37 -0500
Received: by iwn32 with SMTP id 32so2896654iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 21:27:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19270.48453.813374.27261@gargle.gargle.HOWL>
References: <19270.48453.813374.27261@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Jan 2010 21:27:17 -0800
Message-ID: <43e72e891001072127w561950b4wb22dbbe7630fb43f@mail.gmail.com>
Subject: Re: [PATCH 7/7] ath9k: Fix monitor mode handling
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2010 at 9:06 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> mac80211 passes appropriate flags indicating whether
> monitor mode is being used. Use this to set the HW opmode.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Cc stable?

  Luis

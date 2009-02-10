Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:64715 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZBJQKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 11:10:22 -0500
Received: by gxk14 with SMTP id 14so2320593gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 08:10:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <18831.57812.450086.800785@gargle.gargle.HOWL>
References: <18831.57812.450086.800785@gargle.gargle.HOWL>
Date: Tue, 10 Feb 2009 11:10:19 -0500
Message-ID: <b6c5339f0902100810g5c768596v880cd654e0da7954@mail.gmail.com> (sfid-20090210_171026_958386_98DA2F97)
Subject: Re: [PATCH 05/10] ath9k: Move regulatory information to a separate
	structure
From: Bob Copeland <bcopeland@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com, Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 9, 2009 at 2:57 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath9k/eeprom.c |   16 ++++++------
>  drivers/net/wireless/ath9k/hw.c     |   37 ++++++++++++++-------------
>  drivers/net/wireless/ath9k/hw.h     |   12 +-------
>  drivers/net/wireless/ath9k/main.c   |    2 +-
>  drivers/net/wireless/ath9k/regd.c   |   48 +++++++++++++++++-----------------
>  drivers/net/wireless/ath9k/regd.h   |   12 ++++++++
>  6 files changed, 66 insertions(+), 61 deletions(-)
>


Heh, I just did this in my own tree, only I called it ah_regdomain.
regulatory is better though.  (My goal is sharing code with ath5k.)

-- 
Bob Copeland %% www.bobcopeland.com

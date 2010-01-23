Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39312 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab0AWTB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 14:01:59 -0500
Received: by yxe17 with SMTP id 17so1853384yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 11:01:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100123182714.15374.3093.stgit@tikku>
References: <20100123182714.15374.3093.stgit@tikku>
Date: Sat, 23 Jan 2010 14:01:58 -0500
Message-ID: <b6c5339f1001231101w46bbd5dbyae0e2a6607aa80f0@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix tx select key null pointer crash with
	hostapd
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2010 at 1:27 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> Pavel Roskin reported a crash in ieee80211_tx_h_select_key():
>
> http://marc.info/?l=linux-wireless&m=126419655108528&w=2
>
> This is a regression from patch "mac80211: move control.hw_key assignment".
> Fix it as suggested by Johannes, adding an else statement to make sure
> that tx->key is not accessed when it's null.
>
> Compile-tested only.
>
> Reported-by: Pavel Roskin <proski@gnu.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>

Tested-by: Bob Copeland <me@bobcopeland.com>

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com

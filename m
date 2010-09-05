Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60749 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0IEUIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 16:08:22 -0400
Received: by vws3 with SMTP id 3so2776307vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Sep 2010 13:08:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20100903T224155-155@post.gmane.org>
References: <AANLkTim_Ou8fFbfsn8AEZFpWBzjnAQuT4S_w8bV5saYD@mail.gmail.com>
	<loom.20100903T224155-155@post.gmane.org>
Date: Sun, 5 Sep 2010 16:08:20 -0400
Message-ID: <AANLkTikdXBsO0Qx2nEV+Ka9X2D55odmGwePMaUGaQi7j@mail.gmail.com>
Subject: Re: mac80211-based commercial router?
From: Bob Copeland <me@bobcopeland.com>
To: jpo <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 3, 2010 at 4:43 PM, jpo <pommnitz@yahoo.com> wrote:

> Android 2.2 comes with AP functionality. Are the Android WLAN drivers mac80211
> based?

No, they aren't.  Does Android really do AP mode or
just adhoc?

wl1251 is an in-tree module for the TI chip used in G1,
but it doesn't support AP mode.  I do not know if there's
a mac80211 driver that supports the broadcom chip used
in other phones.

-- 
Bob Copeland %% www.bobcopeland.com

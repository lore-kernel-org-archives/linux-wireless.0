Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63722 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0IEWPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Sep 2010 18:15:04 -0400
Received: by qwh6 with SMTP id 6so3382365qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Sep 2010 15:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikdXBsO0Qx2nEV+Ka9X2D55odmGwePMaUGaQi7j@mail.gmail.com>
References: <AANLkTim_Ou8fFbfsn8AEZFpWBzjnAQuT4S_w8bV5saYD@mail.gmail.com>
 <loom.20100903T224155-155@post.gmane.org> <AANLkTikdXBsO0Qx2nEV+Ka9X2D55odmGwePMaUGaQi7j@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 6 Sep 2010 00:14:42 +0200
Message-ID: <AANLkTinu_4tsfJ=0CXS7yuuiqw0X5juqjP_T_edw0b4Y@mail.gmail.com>
Subject: Re: mac80211-based commercial router?
To: Bob Copeland <me@bobcopeland.com>
Cc: jpo <pommnitz@yahoo.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 5, 2010 at 10:08 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Sep 3, 2010 at 4:43 PM, jpo <pommnitz@yahoo.com> wrote:
>
>> Android 2.2 comes with AP functionality. Are the Android WLAN drivers mac80211
>> based?
>
> No, they aren't.  Does Android really do AP mode or
> just adhoc?
>
> wl1251 is an in-tree module for the TI chip used in G1,
> but it doesn't support AP mode.  I do not know if there's
> a mac80211 driver that supports the broadcom chip used
> in other phones.

AFAIK BCM4325 should be doable, especially if it is attached via SDIO
bus. In phones where SPI is used, it is more problematic, as b43
doesn't support SPI.

>
> --
> Bob Copeland %% www.bobcopeland.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

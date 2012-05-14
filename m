Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37956 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab2ENNZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 09:25:38 -0400
Received: by vbbff1 with SMTP id ff1so4830864vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 06:25:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOpc7mEHhZuFdUzzTzXVdn3-DzWuoi-N02Ts1t2xHdNfAGFZhA@mail.gmail.com>
References: <CAOpc7mHADqRcvXgg-8JoVfsoDh0_cZnkqBFS3AadwS6x0gtg7g@mail.gmail.com>
	<CAD2nsn2G67v0rMtQxvqvFpVPwrU2GXR9+zYRutaT8GuRpLoiZQ@mail.gmail.com>
	<CAOpc7mEHhZuFdUzzTzXVdn3-DzWuoi-N02Ts1t2xHdNfAGFZhA@mail.gmail.com>
Date: Mon, 14 May 2012 18:55:37 +0530
Message-ID: <CAD2nsn1CddAK_-gAg69DTvRckWNk574KCoOvwvTTCQBDu_CyHg@mail.gmail.com> (sfid-20120514_152541_624178_F2F2DFB3)
Subject: Re: [BUG, ath9k]: NUL bytes at end of /sys/kernel/debug/ieee80211/phy0/ath9k/modal_eeprom
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> root@/sys/kernel/debug/ieee80211/phy0/ath9k# xxd <modal_eeprom | tail -4
> 0000630: 2036 0a20 2020 2020 2020 2054 5820 4469   6.        TX Di
> 0000640: 7665 7273 6974 7920 3a20 2020 2020 2020  versity :
> 0000650: 2020 2030 0a00 0000 0000 0000 0000 0000     0............
> 0000660: 0000 0000 0000 0000 0000 0000            ............
>
> --


will soon send a RFC patch for your testing, i tested this it seems to
be working!


-- 
thanks,
shafi

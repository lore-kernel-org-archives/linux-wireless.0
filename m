Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52540 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab2ENIXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 04:23:05 -0400
Received: by vbbff1 with SMTP id ff1so4579764vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 01:23:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOpc7mHADqRcvXgg-8JoVfsoDh0_cZnkqBFS3AadwS6x0gtg7g@mail.gmail.com>
References: <CAOpc7mHADqRcvXgg-8JoVfsoDh0_cZnkqBFS3AadwS6x0gtg7g@mail.gmail.com>
Date: Mon, 14 May 2012 13:53:04 +0530
Message-ID: <CAD2nsn2G67v0rMtQxvqvFpVPwrU2GXR9+zYRutaT8GuRpLoiZQ@mail.gmail.com> (sfid-20120514_102311_066300_D31E0F26)
Subject: Re: [BUG, ath9k]: NUL bytes at end of /sys/kernel/debug/ieee80211/phy0/ath9k/modal_eeprom
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, May 14, 2012 at 1:40 PM, Holger Schurig
<holgerschurig@googlemail.com> wrote:
> At first I wondered why "grep -i ant ." in this phy0/ath9k directory
> just said "Binary file modal_eeprom matches". But when I used "less
> modal_eeprom", I saw a bunch of NUL bytes at the end of the virtual
> file.

please dump the whole contents you had got

>
> --
> http://www.holgerschurig.de
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi

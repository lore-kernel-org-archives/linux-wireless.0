Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39305 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2FSJgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 05:36:52 -0400
Received: by obbtb18 with SMTP id tb18so9787244obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 02:36:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com>
References: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com>
Date: Tue, 19 Jun 2012 15:06:52 +0530
Message-ID: <CAD2nsn04Bi5aNMBMLWGm9uQwTXzT8GnDfHZcBP8-+vMEgqBCag@mail.gmail.com> (sfid-20120619_113655_976763_21745838)
Subject: Re: Atheros [168c 0034] can't enable wireless button LED.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matt,

> I tested the latest kernel v3.5-rc3 ath9k for the Atheros [168c 0034],
> code name is Miami. I found no matter how I press the wifi button to
> enable/disable the wifi, it doesn't work to me.
> Even I found the rfkill status for this interface is not changing.

its a AR9462please poke at the register  #define AR_GPIO_IN  -> 0x402c : 0x404c)
i remember testing it in a acer laptop, it was working.

>
> --
> Thank you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi

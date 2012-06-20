Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38674 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2FTDYN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 19 Jun 2012 23:24:13 -0400
Received: by bkcji2 with SMTP id ji2so5767984bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 20:24:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn04Bi5aNMBMLWGm9uQwTXzT8GnDfHZcBP8-+vMEgqBCag@mail.gmail.com>
References: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com>
	<CAD2nsn04Bi5aNMBMLWGm9uQwTXzT8GnDfHZcBP8-+vMEgqBCag@mail.gmail.com>
Date: Wed, 20 Jun 2012 11:24:03 +0800
Message-ID: <CALx5=V-MEZVNkQ0SqqtLqBcDG_Dkp1V6XjiZEv4BBSVn9JQpCw@mail.gmail.com> (sfid-20120620_052416_705364_BBED8D88)
Subject: Re: Atheros [168c 0034] can't enable wireless button LED.
From: Matt Chen <machen@suse.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

2012/6/19 Mohammed Shafi <shafi.wireless@gmail.com>:
> Hi Matt,
>
>> I tested the latest kernel v3.5-rc3 ath9k for the Atheros [168c 0034],
>> code name is Miami. I found no matter how I press the wifi button to
>> enable/disable the wifi, it doesn't work to me.
>> Even I found the rfkill status for this interface is not changing.
>
> its a AR9462please poke at the register  #define AR_GPIO_IN  -> 0x402c : 0x404c)
I do
1) echo 0x402c > regidx
     watch -n 1 regval
2) echo 0x404c > regidx
    watch -n1 regval
> i remember testing it in a acer laptop, it was working.
Both 1) and 2) shows no different in their value no matter how I press
the wifi button. :(

>>
>> --
>> Thank you.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> thanks,
> shafi
>



-- 
Thank you.

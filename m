Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f180.google.com ([74.125.82.180]:50540 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1IPQJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 12:09:20 -0400
Received: by wyj26 with SMTP id 26so4936652wyj.11
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 09:09:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E737241.2080301@qca.qualcomm.com>
References: <4E737241.2080301@qca.qualcomm.com>
Date: Fri, 16 Sep 2011 21:39:18 +0530
Message-ID: <CAD2nsn14EnEWyu2ifM6-5evQN4qGqe4Me7wsZ=xLPt+RBpJeWw@mail.gmail.com> (sfid-20110916_180925_681030_A3DCCA28)
Subject: Re: ath9k_htc: "No free RX buffer" in monitor mode
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, Sep 16, 2011 at 9:28 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Hi,
>
> I was testing monitor mode with ath9k_htc and my laptop got slower. Then
> I noticed this:
>
> [ 9246.606150] ath: No free RX buffer
> [ 9246.606156] ath: No free RX buffer
> [ 9246.606582] ath: No free RX buffer
> [ 9246.606590] ath: No free RX buffer
>
> And I saw it quite a lot:

we saw this some time back in AP mode occasionally and it never came
up for as in monitor mode. we need to fix this.
i will try to fix this.

>
> $ grep "ath: No free" /var/log/syslog | wc -l
> 870950
>
> Kalle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi

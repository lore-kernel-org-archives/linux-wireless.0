Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41042 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab2FUG1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 02:27:37 -0400
Received: by eeit10 with SMTP id t10so53974eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 23:27:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20450.41898.681964.746059@gargle.gargle.HOWL>
References: <0a2a155916bf9ddc1974347ae6b0999b.squirrel@www.infidigm.net>
 <CAD2nsn0C5xC5_VjxpuiwPTYunY21JhHF7pu6z+mDYRupMieGdQ@mail.gmail.com> <20450.41898.681964.746059@gargle.gargle.HOWL>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 21 Jun 2012 16:27:14 +1000
Message-ID: <CAGRGNgUH_zFLHWkpsN+XU=EMJ+h3or28d+ZBHJc-sUtBCy6ooA@mail.gmail.com> (sfid-20120621_082740_914757_F439E290)
Subject: Re: ath9k support ar9374?
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>, drwho@infidigm.net,
	linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Jun 21, 2012 at 2:31 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Mohammed Shafi wrote:
>> i think no, ath9k_htc(USB)
>> http://linuxwireless.org/en/users/Drivers/ath9k_htc
>
> No, it doesn't.

A quick google search implies that it's an ath6k device.

http://cateee.net/lkddb/web-lkddb/ATH6KL.html
http://lxr.linux.no/#linux+v3.4.3/drivers/net/wireless/ath/ath6kl/usb.c#L395

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab2FUJgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 05:36:44 -0400
Message-ID: <4FE2EB27.2010202@qca.qualcomm.com> (sfid-20120621_113648_416073_62954D4B)
Date: Thu, 21 Jun 2012 12:36:39 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	<drwho@infidigm.net>, <linux-wireless@vger.kernel.org>
Subject: Re: ath9k support ar9374?
References: <0a2a155916bf9ddc1974347ae6b0999b.squirrel@www.infidigm.net> <CAD2nsn0C5xC5_VjxpuiwPTYunY21JhHF7pu6z+mDYRupMieGdQ@mail.gmail.com> <20450.41898.681964.746059@gargle.gargle.HOWL> <CAGRGNgUH_zFLHWkpsN+XU=EMJ+h3or28d+ZBHJc-sUtBCy6ooA@mail.gmail.com>
In-Reply-To: <CAGRGNgUH_zFLHWkpsN+XU=EMJ+h3or28d+ZBHJc-sUtBCy6ooA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 06/21/2012 09:27 AM, Julian Calaby wrote:
> On Thu, Jun 21, 2012 at 2:31 PM, Sujith Manoharan
> <c_manoha@qca.qualcomm.com> wrote:
>> Mohammed Shafi wrote:
>>> i think no, ath9k_htc(USB)
>>> http://linuxwireless.org/en/users/Drivers/ath9k_htc
>>
>> No, it doesn't.
> 
> A quick google search implies that it's an ath6k device.
> 
> http://cateee.net/lkddb/web-lkddb/ATH6KL.html
> http://lxr.linux.no/#linux+v3.4.3/drivers/net/wireless/ath/ath6kl/usb.c#L395

That's right, AR9374 is basically AR6004 with USB. Don't ask me why :)

Latest ath6kl should support is. I can't remember what kernel version
has the full support, but I'm pretty sure 3.3 didn't support it yet.

But I should update ath6kl documentation to mention this, thanks for
pointing this out.

Kalle

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:57835 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaLUT4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 14:56:04 -0500
Message-ID: <549725D1.2090402@broadcom.com> (sfid-20141221_205625_408105_E5420BFD)
Date: Sun, 21 Dec 2014 20:56:01 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"Rob Herring" <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 03/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
References: <1419162233-19492-1-git-send-email-arend@broadcom.com> <1419162233-19492-4-git-send-email-arend@broadcom.com> <B1CB9465-1353-411C-9B3C-42DEFBFDBBE0@holtmann.org>
In-Reply-To: <B1CB9465-1353-411C-9B3C-42DEFBFDBBE0@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/14 18:50, Marcel Holtmann wrote:
> Hi Arend,
>
>> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
>> index 0f01fe0..61f8318 100644
>> --- a/include/linux/mmc/sdio_ids.h
>> +++ b/include/linux/mmc/sdio_ids.h
>> @@ -29,6 +29,8 @@
>> #define SDIO_DEVICE_ID_BROADCOM_4329		0x4329
>> #define SDIO_DEVICE_ID_BROADCOM_4330		0x4330
>> #define SDIO_DEVICE_ID_BROADCOM_4334		0x4334
>> +#define SDIO_DEVICE_ID_BROADCOM_43340		43340
>> +#define SDIO_DEVICE_ID_BROADCOM_43341		43341
>
> the general preference is to have these values in hex. I get the fact that they map the marketing number, but that could be just stated in a comment after the hex number.

Will change that.

>> #define SDIO_DEVICE_ID_BROADCOM_4335_4339	0x4335
>> #define SDIO_DEVICE_ID_BROADCOM_43362		43362
>> #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
>
> Is there any chance that you can also send patches against sdio.ids database from systemd:
>
> http://cgit.freedesktop.org/systemd/systemd/tree/hwdb/sdio.ids
>
> That would allow for udev to provide friendly names and they would also be shown using networkctl.

Ah, my bad. I recall you asking that question a while ago when I started 
adding broadcom device ids here. I found a git clone on my system and 
already had a patch there for almost a year ;-)

Regards,
Arend

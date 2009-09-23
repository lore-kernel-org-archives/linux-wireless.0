Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:61294 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZIWFgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 01:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <1253666644.2931.7.camel@localhost.localdomain>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-3-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-4-git-send-email-tomas.winkler@intel.com>
	 <1253666644.2931.7.camel@localhost.localdomain>
Date: Wed, 23 Sep 2009 08:36:41 +0300
Message-ID: <1ba2fa240909222236w5dc8f163p20e414073027e2e8@mail.gmail.com>
Subject: Re: [PATCH 3/3] i2400m-sdio: select IWMC3200TOP in Kconfig
From: Tomas Winkler <tomasw@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, yi.zhu@intel.com,
	inaky.perez-gonzalez@intel.com, cindy.h.kao@intel.com,
	guy.cohen@intel.com, ron.rindjunsky@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 3:44 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Tomas,
>
>> i2400m-sdio requires iwmc3200top for its operation
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  drivers/net/wimax/i2400m/Kconfig |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wimax/i2400m/Kconfig b/drivers/net/wimax/i2400m/Kconfig
>> index d623b3d..7368ad5 100644
>> --- a/drivers/net/wimax/i2400m/Kconfig
>> +++ b/drivers/net/wimax/i2400m/Kconfig
>> @@ -25,6 +25,7 @@ config WIMAX_I2400M_SDIO
>>       tristate "Intel Wireless WiMAX Connection 2400 over SDIO"
>>       depends on WIMAX && MMC
>>       select WIMAX_I2400M
>> +     select IWMC3200TOP
>>       help
>>         Select if you have a device based on the Intel WiMAX
>>         Connection 2400 over SDIO.
>
> this is not true actually. Since the WiMAX hardware in my laptop doesn't
> require the top driver.
>
SDIO?

Thanks
Tomas

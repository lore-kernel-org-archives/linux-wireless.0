Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45508 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZJTLxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 07:53:30 -0400
MIME-Version: 1.0
In-Reply-To: <20091019.215457.43252934.davem@davemloft.net>
References: <1255806576-26869-1-git-send-email-tomas.winkler@intel.com>
	 <20091019.215457.43252934.davem@davemloft.net>
Date: Tue, 20 Oct 2009 13:53:33 +0200
Message-ID: <1ba2fa240910200453k4638dc6cm8c8911353ea85b60@mail.gmail.com>
Subject: Re: [PATCH net-next V2 1/3] iwmc3200top: Add Intel Wireless MultiCom
	3200 top driver.
From: Tomas Winkler <tomasw@gmail.com>
To: David Miller <davem@davemloft.net>,
	Marcel Holtmann <marcel@holtmann.org>
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2009 at 6:54 AM, David Miller <davem@davemloft.net> wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
> Date: Sat, 17 Oct 2009 21:09:34 +0200
>
>> This patch adds Intel Wireless MultiCom 3200 top driver.
>> IWMC3200 is 4Wireless Com CHIP (GPS/BT/WiFi/WiMAX).
>> Top driver is responsible for device initialization and firmware download.
>> Firmware handled by top is responsible for top itself and
>> as well as bluetooth and GPS coms. (Wifi and WiMax provide their own firmware)
>> In addition top driver is used to retrieve firmware logs
>> and supports other debugging features
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>
> Applied to net-next-2.6

Thanks Dave

Marcel
I want to send out now the BT driver, would like the patch against
bluetooth-next-2.6.git, then I wait till you sync or can you also pick
it from net-next if Dave is OK with that?

Thanks
Tomas

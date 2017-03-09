Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44828 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbdCIIBE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:01:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k_htc: Add support of AirTies 1eda:2315 AR9271 device
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487261622-21338-1-git-send-email-hanipouspilot@gmail.com>
References: <1487261622-21338-1-git-send-email-hanipouspilot@gmail.com>
To: Dmitry Tunin <hanipouspilot@gmail.com>
CC: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Dmitry Tunin" <hanipouspilot@gmail.com>, <stable@vger.kernel.org>
Message-ID: <f71755244feb46fd8741ca9bea3b497e@euamsexm01a.eu.qualcomm.com> (sfid-20170309_090310_825620_1F183DCC)
Date: Thu, 9 Mar 2017 09:00:04 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dmitry Tunin <hanipouspilot@gmail.com> wrote:
> T:  Bus=01 Lev=02 Prnt=02 Port=02 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
> D:  Ver= 2.00 Cls=ff(vend.) Sub=ff Prot=ff MxPS=64 #Cfgs=  1
> P:  Vendor=1eda ProdID=2315 Rev=01.08
> S:  Manufacturer=ATHEROS
> S:  Product=USB2.0 WLAN
> S:  SerialNumber=12345
> C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
> I:  If#= 0 Alt= 0 #EPs= 6 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
> 
> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
> Cc: stable@vger.kernel.org

Patch applied to ath-next branch of ath.git, thanks.

16ff1fb0e32f ath9k_htc: Add support of AirTies 1eda:2315 AR9271 device

-- 
https://patchwork.kernel.org/patch/9577679/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

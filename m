Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2410 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab3JDHsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 03:48:21 -0400
Message-ID: <524E72B7.5000102@broadcom.com> (sfid-20131004_094833_632277_2F1C67E2)
Date: Fri, 4 Oct 2013 09:48:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Eugene Krasnikov" <k.eugene.e@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm
 WCN3660/WCN3680 hardware
References: <1380234106-12802-1-git-send-email-k.eugene.e@gmail.com>
 <CAFSJ42bybEGtkzJ99fZHrcPs=gTnvJVHxM7d8anJvn1VOs7V7A@mail.gmail.com>
 <20131003205710.GH3142@tuxdriver.com>
 <CAFSJ42ZwJzd46UXE2crzuaMVRLzre9SVm_vFcQ-KAVY6Q9c3QQ@mail.gmail.com>
In-Reply-To: <CAFSJ42ZwJzd46UXE2crzuaMVRLzre9SVm_vFcQ-KAVY6Q9c3QQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2013 11:22 PM, Eugene Krasnikov wrote:
> Hm, weird... do not see this problem myself. Let me try to sync latest
> wireless-next and will try to apply latest patch from this mailthread
> on top.

Hi Eugene,

Do you build the driver as module. John is building it built-in then kernel.

Gr. AvS

> P.S. If somebody esle can try to apply this patch and build that would
> be useful to know if problem is visible on others PCs as well.
>
> 2013/10/3 John W. Linville <linville@tuxdriver.com>:
>> On Thu, Sep 26, 2013 at 11:25:18PM +0100, Eugene Krasnikov wrote:
>>> Hi John,
>>>
>>> This is the latest version of wcn36xx driver on top of current
>>> wireless-next tree. Please let me know if you have any problems with
>>> applying it.
>>>
>>> 2013/9/26 Eugene Krasnikov <k.eugene.e@gmail.com>:
>>>> This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
>>>> far WCN3660/WCN3680 is available only on MSM platform.
>>>>
>>>> Firmware can be found here:
>>>> https://www.codeaurora.org/cgit/external/hisense/platform/vendor/qcom-opensource/wlan/prima/tree/firmware_bin?h=8130_CS
>>>>
>>>> Wiki page is available here:
>>>> http://wireless.kernel.org/en/users/Drivers/wcn36xx
>>>>
>>>> A lot people made a contribution to this driver. Here is the list in
>>>> alphabetical order:
>>>>
>>>> Eugene Krasnikov <k.eugene.e@gmail.com>
>>>> Kalle Valo <kvalo@qca.qualcomm.com>
>>>> Olof Johansson <dev@skyshaper.net>
>>>> Pontus Fuchs <pontus.fuchs@gmail.com>
>>>> Yanbo Li <yanbol@qti.qualcomm.com>
>>>>
>>>> Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
>>
>> 'make allyesconfig' yield this:
>>
>>    LD      drivers/net/wireless/ath/ath.o
>>    LD      drivers/net/wireless/ath/built-in.o
>> drivers/net/wireless/ath/wcn36xx/built-in.o: In function `_GLOBAL__sub_I_65535_0_wcn36xx_set_default_rates':
>> /home/linville/git/wireless-next/drivers/net/wireless/ath/wcn36xx/main.c:302: multiple definition of `debug_mask'
>> drivers/net/wireless/ath/ath6kl/built-in.o:/home/linville/git/wireless-next/drivers/net/wireless/ath/ath6kl/cfg80211.c:1208: first defined here
>> make[2]: *** [drivers/net/wireless/ath/built-in.o] Error 1
>> make[1]: *** [drivers/net/wireless/ath] Error 2
>> make: *** [drivers/net/wireless/] Error 2
>>
>> --
>> John W. Linville                Someday the world will need a hero, and you
>> linville@tuxdriver.com                  might be all we have.  Be ready.
>
>
>



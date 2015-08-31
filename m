Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34078 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbbHaLyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 07:54:53 -0400
Received: by vkhf67 with SMTP id f67so36827514vkh.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 04:54:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <26c3f35fd9e74b1d80e80077c19b6717@SC-EXCH04.marvell.com>
References: <CAAfyv36YLsEVarY6J8H-=Vcox=ktgeCUkqurHnAXzj_UFfthYw@mail.gmail.com>
	<26c3f35fd9e74b1d80e80077c19b6717@SC-EXCH04.marvell.com>
Date: Mon, 31 Aug 2015 13:54:52 +0200
Message-ID: <CAAfyv36Xf4f33wZvKMeTomyr_T-LKKMYkpYQwWt6B83UthFr8Q@mail.gmail.com> (sfid-20150831_135456_537292_BCAA6516)
Subject: Re: kernel log flooded with GET_CMD_NODE: cmd node not available
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

find below dmesg

On Mon, Aug 31, 2015 at 1:44 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Belisko,
>
>> I'm running kernel 4.1 (no code changes in mwifiex) on custom board with
>> mwrvl sd8787 sdio wifi card. Everything works fine but when I start
>> hostapd and connect to device from PC  and open device webpage I can see
>> in log many of such messages (~100 same lines):
>> GET_CMD_NODE: cmd node not available
>> PREP_CMD: no free cmd node
>
> Could you share complete dmesg log?
>
> Regards,
> Amitkumar

[    8.014039] udevd[84]: starting version 182
[    9.951563] cfg80211: Calling CRDA to update world regulatory domain
[   11.571515] Bluetooth: Vendor=0x2df, Device=0x911a, Class=255, Fn=2
[   13.111987] cfg80211: Calling CRDA to update world regulatory domain
[   16.271552] cfg80211: Calling CRDA to update world regulatory domain
[   17.062728] random: nonblocking pool is initialized
[   17.302971] Bluetooth: FW download over, size 456660 bytes
[   17.953975] mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
[   17.954011] mwifiex_sdio mmc0:0001:1: WLAN FW is active
[   18.067233] ieee80211 phy0: ignoring F/W country code US
[   18.148485] mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0
(14.66.35.p25)
[   19.432103] cfg80211: Calling CRDA to update world regulatory domain
[   22.594066] cfg80211: Calling CRDA to update world regulatory domain
[   25.751568] cfg80211: Calling CRDA to update world regulatory domain
[   28.911566] cfg80211: Calling CRDA to update world regulatory domain
[   29.533669] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   30.069695] net eth0: initializing cpsw version 1.12 (0)
[   30.170530] net eth0: phy found : id is : 0x4dd076
[   30.170779] libphy: PHY  not found
[   30.175233] net eth0: phy  not found on slave 1
[   30.188658] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   30.658135] net eth0: initializing cpsw version 1.12 (0)
[   30.733308] net eth0: phy found : id is : 0x4dd076
[   30.733523] libphy: PHY  not found
[   30.737088] net eth0: phy  not found on slave 1
[   30.788634] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   32.071633] cfg80211: Calling CRDA to update world regulatory domain
[   35.231609] cfg80211: Exceeded CRDA call max attempts. Not calling CRDA
[   44.044608] IPv6: ADDRCONF(NETDEV_UP): uap0: link is not ready
[   44.265485] net eth0: initializing cpsw version 1.12 (0)
[   44.343401] net eth0: phy found : id is : 0x4dd076
[   44.343620] libphy: PHY  not found
[   44.347189] net eth0: phy  not found on slave 1
[   44.391060] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   44.637269] IPv6: ADDRCONF(NETDEV_UP): uap0: link is not ready
[   66.680521] IPv6: ADDRCONF(NETDEV_CHANGE): uap0: link becomes ready
[  181.559447] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.566655] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.577016] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.584219] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.596305] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.603518] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.616659] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.623871] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.630337] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.637520] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.643923] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.651103] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.657904] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.665091] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.671702] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.678887] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.699303] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.706515] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.718104] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.725309] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.734723] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.741922] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.752621] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.759828] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.769583] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.776787] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.784389] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.791585] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.806670] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.813876] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.823657] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.830861] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.841200] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.848400] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.861088] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.868291] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.877331] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.884533] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.891671] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.898854] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.907407] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.914605] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.921423] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.928607] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.942009] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.949218] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.958798] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.966000] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.978141] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  181.985344] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  181.995284] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.002488] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.014523] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.021731] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.031546] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.038753] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.050719] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.057923] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.069146] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.076350] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.085102] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.092297] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.103276] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.110478] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.121156] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.128360] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
[  182.134750] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
[  182.141927] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node

BR,

marek
-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

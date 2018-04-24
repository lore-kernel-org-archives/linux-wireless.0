Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46478 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbeDXRMX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:12:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/17] rtlwifi: halmac: Add new module halmac
References: <20180403075332.3344-1-pkshih@realtek.com>
Date: Tue, 24 Apr 2018 20:12:15 +0300
In-Reply-To: <20180403075332.3344-1-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Tue, 3 Apr 2018 15:53:15 +0800")
Message-ID: <87muxsbkb4.fsf@purkki.adurom.net> (sfid-20180424_191227_333321_27E3812B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> v2: remove indirection to get halmac ops
>     Only patches 1/17 and 11/17 are changed.
>
> Patches 1/17-3/17 are added structure to support this module.
> Patches 4/17-16/17 add new files.
> Patch 17/17 add this module to Makefile and Kconfig.
>
> Ping-Ke Shih (17):
>   rtlwifi: add halmac structure to wifi.h
>   rtlwifi: add debug ID COMP_HALMAC
>   rtlwifi: add dmdef.h to share with driver and other modules
>   rtlwifi: halmac: add main definition used by halmac
>   rtlwifi: halmac: describe number and size of chip functions
>   rtlwifi: halmac: add definitions of registers and bit fields
>   rtlwifi: halmac: add definition of TX/RX descriptor
>   rtlwifi: halmac: add GPIO pin/pinmux definitions
>   rtlwifi: halmac: add power sequence to turn on/off wifi card
>   rtlwifi: halmac: access efuse through halmac helper functions
>   rtlwifi: halmac: add files to implement halmac ops
>   rtlwifi: halmac: add halmac init/deinit functions
>   rtlwifi: halmac: add firmware related functions and definitions
>   rtlwifi: halmac: add bus interface commands
>   rtlwifi: halmac: add to control WiFi mac functions and registers
>   rtlwifi: halmac: add to support BB and RF functions
>   rtlwifi: add halmac to Makefile and Kconfig

BTW, I don't see patch 6 in patchwork. Did it get lost?

      [v2,01/17] rtlwifi: add halmac structure to wifi.h           2018-04-03 Ping-Ke Shih New
      [v2,02/17] rtlwifi: add debug ID COMP_HALMAC                 2018-04-03 Ping-Ke Shih New
      [v2,03/17] rtlwifi: add dmdef.h to share with driver and.... 2018-04-03 Ping-Ke Shih New
      [v2,04/17] rtlwifi: halmac: add main definition used by h... 2018-04-03 Ping-Ke Shih New
      [v2,05/17] rtlwifi: halmac: describe number and size of c... 2018-04-03 Ping-Ke Shih New
      [v2,07/17] rtlwifi: halmac: add definition of TX/RX descr... 2018-04-03 Ping-Ke Shih New
      [v2,08/17] rtlwifi: halmac: add GPIO pin/pinmux definitions  2018-04-03 Ping-Ke Shih New
      [v2,09/17] rtlwifi: halmac: add power sequence to turn on... 2018-04-03 Ping-Ke Shih New
      [v2,10/17] rtlwifi: halmac: access efuse through halmac h... 2018-04-03 Ping-Ke Shih New
      [v2,11/17] rtlwifi: halmac: add files to implement halmac... 2018-04-03 Ping-Ke Shih New
      [v2,12/17] rtlwifi: halmac: add halmac init/deinit functions 2018-04-03 Ping-Ke Shih New
      [v2,13/17] rtlwifi: halmac: add firmware related function... 2018-04-03 Ping-Ke Shih New
      [v2,14/17] rtlwifi: halmac: add bus interface commands       2018-04-03 Ping-Ke Shih New
      [v2,15/17] rtlwifi: halmac: add to control WiFi mac funct... 2018-04-03 Ping-Ke Shih New
      [v2,16/17] rtlwifi: halmac: add to support BB and RF func... 2018-04-03 Ping-Ke Shih New
      [v2,17/17] rtlwifi: add halmac to Makefile and Kconfig       2018-04-03 Ping-Ke Shih New

-- 
Kalle Valo

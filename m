Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42764 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbZLDVlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 16:41:47 -0500
Received: by yxe17 with SMTP id 17so2480979yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 13:41:54 -0800 (PST)
Message-ID: <4B198081.2090901@lwfinger.net>
Date: Fri, 04 Dec 2009 15:34:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgS2FpamFubcOka2k=?= <antti@kaijanmaki.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>	 <4B169608.3010902@lwfinger.net> <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>
In-Reply-To: <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antti,

>From our private tests, you can see my problem with making a change in
the rfkill handling. Most of the devices in the hands of the
developers do not honor the rfkill switch; however, the one that does
works with the current code. This code also matches the latest version
of the vendor drivers for the RTL8187L
(rtl8187L_linux_26.1038.0626.2009.release) and RTL8187B
(rtl8187B_linux_26.1036.0708.2008). If you have newer drivers from
Realtek, I would be interested in seeing them.

To make a special case for your system, we need to be able to
differentiate it from all other systems. We know that the chip has the
same cut (RTL8187BvE V0) as Hin-Tak's, and the same vendor ID (0x04).
We do have devices that require parsing additional USB data to get the
setup properly initialized. Please send me the full output of the
'lsusb -v' command for the rtl8187 device. I will get the same info
from Hin-Tak to see if we can differentiate your two devices.

Thanks,

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36942 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab1IZPk5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 11:40:57 -0400
Received: by yib18 with SMTP id 18so4319811yib.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 08:40:56 -0700 (PDT)
Message-ID: <4E809D0F.3080405@lwfinger.net> (sfid-20110926_174105_869828_DD53F610)
Date: Mon, 26 Sep 2011 10:41:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henrik Friedrichsen <hrkfdn@gmail.com>
CC: wwguy <wey-yi.w.guy@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com> <CAJTrwG47wxJMjxo9_gtwut0w17FS2Qz7BOBPc2XCLo39M7WvSQ@mail.gmail.com> <1317048872.2400.4.camel@wwguy-ubuntu> <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
In-Reply-To: <CAJTrwG5CQKn9=1=HUDX1L5PsFbGws_zK1DTvot9i=KcMX7SwkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2011 10:20 AM, Henrik Friedrichsen wrote:

>> 1. AP brand and model
> AVM Fritz!Box Fon WLAN 7390

FWIW, we are working on a problem with using rtl8192cu and a Fritz!Box 7270 that 
doesn't seem to happen with any other AP. Our symptoms are different, but therre 
might be a related cause. If you find a fix, please let the list know. Our 
debugging is waiting for either Realtek to get access to such an AP, or for the 
OP to provide a Wireshark air dump. That AP is too pricey for my budget.

Larry



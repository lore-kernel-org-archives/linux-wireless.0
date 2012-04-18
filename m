Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753150Ab2DRAhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 20:37:36 -0400
Message-ID: <4F8E0CBE.6010103@sipsolutions.net> (sfid-20120418_023750_192533_B2C9BEC0)
Date: Tue, 17 Apr 2012 17:37:18 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Dominik Feser <dominik.feser@googlemail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: wlan0 not present
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <4F8DC25E.9090702@broadcom.com> <B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com> (sfid-20120417_234151_656508_5FC39580)
In-Reply-To: <B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com> (sfid-20120417_234151_656508_5FC39580)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> iwlwifi 0000:02:00.0: edf81e1c
> iwlwifi 0000:02:00.0: c9933e1c
> iwlwifi 0000:02:00.0: c9933de8
> iwlwifi 0000:02:00.0: PCI INT A disabled

These messages are odd, must be some %pV thing not working correctly.

> It did not work before because I had to rebuild the kernel with wireless support and compile compat-wireless for it. This seemed to me as the only way to get the Centrino Advanced-N 6205 to work.
> Am I wrong? May it be that I am missing the firmware? I tried to copy a ucode file to /lib/firmware but the behavior did not change. Overlooking the dmesg output no module is complaining about missing firmware files...

I think those messages would in fact be complaining about missing 
firmware if they'd get printed correctly.

johannes

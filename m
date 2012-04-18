Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59842 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab2DRGtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 02:49:08 -0400
Received: by bkcik5 with SMTP id ik5so5161260bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 23:49:07 -0700 (PDT)
Subject: Re: wlan0 not present
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Dominik Feser <dominik.feser@googlemail.com>
In-Reply-To: <4F8E0CBE.6010103@sipsolutions.net>
Date: Wed, 18 Apr 2012 08:49:02 +0200
Cc: Dominik Feser <dominik.feser@googlemail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Message-Id: <0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com> (sfid-20120418_084917_627038_086FAE39)
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <4F8DC25E.9090702@broadcom.com> <B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com> (sfid-20120417_234151_656508_5FC39580) <4F8E0CBE.6010103@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

Can you be a bit more specific about your thoughts? What do you think is not working correctly?
Am I understanding you correctly? You think I have a firmware problem?

Dominik

Am 18.04.2012 um 02:37 schrieb Johannes Berg:

>> iwlwifi 0000:02:00.0: edf81e1c
>> iwlwifi 0000:02:00.0: c9933e1c
>> iwlwifi 0000:02:00.0: c9933de8
>> iwlwifi 0000:02:00.0: PCI INT A disabled
> 
> These messages are odd, must be some %pV thing not working correctly.
> 
>> It did not work before because I had to rebuild the kernel with wireless support and compile compat-wireless for it. This seemed to me as the only way to get the Centrino Advanced-N 6205 to work.
>> Am I wrong? May it be that I am missing the firmware? I tried to copy a ucode file to /lib/firmware but the behavior did not change. Overlooking the dmesg output no module is complaining about missing firmware files...
> 
> I think those messages would in fact be complaining about missing firmware if they'd get printed correctly.
> 
> johannes


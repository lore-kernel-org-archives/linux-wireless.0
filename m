Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43943 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab2GINbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:31:22 -0400
Received: by gglu4 with SMTP id u4so10035041ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 06:31:22 -0700 (PDT)
Message-ID: <4FFADD27.3020501@lwfinger.net> (sfid-20120709_153131_253099_8A3CAAD7)
Date: Mon, 09 Jul 2012 08:31:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP v2] rtlwifi: rtl8192su subdriver
References: <4FEF0BD1.90405@gmail.com> <4FFAD137.3020806@gtri.gatech.edu>
In-Reply-To: <4FFAD137.3020806@gtri.gatech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 07:40 AM, Joshua Roys wrote:
> On 06/30/2012 10:23 AM, Xose Vazquez Perez wrote:
>> on Mon, 7 May 2012 Joshua Roys wrote:
>>
>>> Currently a WIP.
>>
>>> A few things have changed between this and the previous version.
>>> Larry Finger's \
>>> patch for handling the race condition with mac80211 and the firmware
>>> callback is used \
>>> instead (rtlwifi: fix for race condition when firmware is cached), and
>>> a new patch \
>>  > [...]
>>
>> hi Joshua,
>>
>> any news on that ?
>
> Hello,
>
> Currently I'm still searching for the hidden/undocumented registers that will
> allow the rtlwifi driver to drive the *su chips.  (The rtlwifi driver uses the
> softmac infrastructure while the current firmware for the *su chips really needs
> a fullmac driver.)

I don't think I believe the business about a fullmac driver. Driver r8712u, 
which does handle the RTL8191SU, uses its own softmac driver.

Larry


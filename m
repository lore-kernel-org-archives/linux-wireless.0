Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64780 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3CGD72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 22:59:28 -0500
Received: by mail-oa0-f46.google.com with SMTP id k1so43724oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 19:59:28 -0800 (PST)
Message-ID: <5138109D.1040605@lwfinger.net> (sfid-20130307_045932_883771_F33DCF9D)
Date: Wed, 06 Mar 2013 21:59:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jenya Y <jenya.gerstmaier@live.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: linux kernel 3.9 rc1 and rtl8187 wireless, unable to
 connect to any available hotspots.
References: <51380336.6030007@live.com> <BLU0-SMTP15357D4D2469B872AE4355CF1E50@phx.gbl>
In-Reply-To: <BLU0-SMTP15357D4D2469B872AE4355CF1E50@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2013 09:14 PM, Jenya Y wrote:
>
> Even though I am presented with a list of available networks, my system with the
> rc1 kernel is not able to connect to any of them.
> It stops at the point where it tries to obtain an IP address.
>
> I tried to delete the Profile of my WiFi and recreate it but no luck.
>
> This issue is only with 3.9rc1, it worked fine with 3.6 to 3.8.2.

I am running 3.9-rc1 from wireless-testing, and both my RTL8187L and RTL8187B 
can connect to WEP, WPA1, and WPA2 networks without a problem. At the moment, it 
is not convenient for me to boot 3.9-rc1 from mainline, but I should be able to 
do that tomorrow.

What kind of encryption are you using, and what is the USB ID for your device as 
shown by the lsusb command?

Larry


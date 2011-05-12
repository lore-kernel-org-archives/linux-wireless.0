Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37401 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1ELO6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:58:03 -0400
Received: by vxi39 with SMTP id 39so1175180vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:58:01 -0700 (PDT)
Message-ID: <4DCBF576.1040802@lwfinger.net> (sfid-20110512_165808_007815_B6B012F5)
Date: Thu, 12 May 2011 09:57:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Flaminigo <sunnyiez@gmail.com>
CC: James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: rtl8192ce.ko doesn't work with 802.11n?
References: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com>	<4DCB3DFF.1030809@lockie.ca> <BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>
In-Reply-To: <BANLkTimEWJbgJJOmCjBoNGtFrSFcoE8aWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2011 08:59 AM, Flaminigo wrote:
> Thank you for the reply. I think N network in the university is OK.
> Because,  old computer connected it without any problem. The windows
> system can also connect it. From the output of wpa_supplicant, the
> authentication part works well. I've tried to use the latest drive
> from realtek. The firmware distribute is exactly the same as that in
> Ubuntu 11.04. But this will make core dump.
>
> I will try some other distributions. But the driver and the kernel are
> the same,  so I don't think this will make any difference.

What kind of 802.11n network is your university running? What is the maximum 
data rate in Mbps? Are they using a 20 or 40 MHz bandwidth? Please have your 
network administrators give you that information so that I can try to duplicate 
the results. With my setup here, I have connected using the 2.4 GHz band with 
rates up to 130 Mbps. My setup uses WPA2-PSK, not EAP, but authentication does 
not seem to be your problem.

Every driver contains information about its authors. Use the 'modinfo rtl8192ce' 
command to get that information. Any reports of problems with a given driver 
should be sent to those listed authors with a Cc to the appropriate mailing 
list. I read the linux-wireless mailing list, thus I saw your posting, but my 
Chinese colleagues do not.

I received a new driver version from Realtek yesterday. I am still going through 
it to port the changes to the kernel driver. It is possible that your problem 
may have been found and fixed, but until you report what exact network 
conditions you have, I will not be able to confirm that.

Larry

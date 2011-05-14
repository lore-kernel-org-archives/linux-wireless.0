Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41684 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab1ENPUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 11:20:30 -0400
Received: by iwn34 with SMTP id 34so2929082iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 08:20:29 -0700 (PDT)
Message-ID: <4DCE9DB8.7080404@lwfinger.net> (sfid-20110514_172033_386332_FCBA247F)
Date: Sat, 14 May 2011 10:20:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Flaminigo <sunnyiez@gmail.com>
CC: James <bjlockie@lockie.ca>, linux-wireless@vger.kernel.org
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

There is a problem with driver rtl8192ce with 802.11n networks that use a 40 MHz 
bandwidth. As you never answered my questions, I don't know if that is the 
problem that you are seeing. If you go to 
http://bugzilla.kernel.org/show_bug.cgi?id=35082, there is a patch that may fix 
your problem. At least it worked here.

Larry


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36471 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab3DXOtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 10:49:39 -0400
Received: by mail-ie0-f171.google.com with SMTP id e11so2183652iej.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 07:49:39 -0700 (PDT)
Message-ID: <5177F100.1070803@lwfinger.net> (sfid-20130424_164943_014682_A096A610)
Date: Wed, 24 Apr 2013 09:49:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Stahn <michael.stahn.42@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Realtek 8192CU not working
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com> <CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com>
In-Reply-To: <CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 09:16 AM, Michael Stahn wrote:
> Hi,
>
> I just checked out the 3.7.10-Kernel driver for the wireless Adapter
> EW 7811Un 802.11n, ID 7392:7811 and it doesn't work: The driver gets
> loaded but some IRQ-errors show up. Using the original driver doesn't
> work either 1) driver needs patching for new kernel-API 2) Patched
> Driver gets loaded but USB directly suspends and the device seems to
> shut down permanently (ifconfig wlan0 up leads to error). I can't
> paste any traces now but perhaps these problems can be confirmed after
> all.

Without the error traces, there is little I can do.

Larry



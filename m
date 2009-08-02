Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52965 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZHBJ0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 05:26:16 -0400
Received: by ewy10 with SMTP id 10so2402524ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 02:26:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249204732.2007.49.camel@johannes.local>
References: <efe7343f0908020214m6d8b2518n51d4264943ce273a@mail.gmail.com>
	 <1249204732.2007.49.camel@johannes.local>
Date: Sun, 2 Aug 2009 10:26:16 +0100
Message-ID: <efe7343f0908020226n4b693defv38546a6f8aa1cfd9@mail.gmail.com>
Subject: Re: Unsupported PHY on B43
From: Luis Correia <luis.f.correia@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes

On Sun, Aug 2, 2009 at 10:18, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Sun, 2009-08-02 at 10:14 +0100, Luis Correia wrote:
>
>> b43-phy1: Broadcom 4322 WLAN found (core revision 16)
>> b43-phy1 ERROR: FOUND UNSUPPORTED PHY (Analog 8, Type 4, Revision 4)
>> b43: probe of ssb0:0 failed with error -95
>> Broadcom 43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]
>
> This is an 11n phy.

Great, an 11n device with only two antennas (they are usually three).

>> I'm available to test drivers, patches, git kernels, the whole lot.
>
> There's nothing available beyond what you have.

Bummer, I guess I'll have to wait then.

>
> johannes
>

Thanks for the info.

Luis Correia
rt2x00 project admin

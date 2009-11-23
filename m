Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:65479 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZKWTU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:20:29 -0500
Received: by ewy19 with SMTP id 19so2187139ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 11:20:34 -0800 (PST)
Message-ID: <4B0AE07F.5030603@gmail.com>
Date: Mon, 23 Nov 2009 20:20:31 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Simon Raffeiner <sturmflut@lieberbiber.de>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 1/6] rt2x00: Only initialize HT on rt2800 devices that
 support it.
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> <1258960565-26736-2-git-send-email-gwingerde@gmail.com> <200911231058.31157.sturmflut@lieberbiber.de>
In-Reply-To: <200911231058.31157.sturmflut@lieberbiber.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/09 10:58, Simon Raffeiner wrote:
> Am Montag, 23. November 2009 08:16:00 schrieb Gertjan van Wingerde:
>> Some RT28xx/RT30xx devices don't support 802.11n, when they are combined with
>> the RF2020 chipset. Ensure that HT is disabled for these devices.
> 
> Hi Gertjan,
> 
> do you know if this fixes the RT2070L chipset? It's an RT3070 descendant without 802.11n support, I cracked the device open and there's no RF2020 to be seen - just a single RT2070L chip. Somebody posted that the RT2070L has the RF part integrated to make it cheaper, maybe RT2070 = RT3070 + RF2020 in a single chip?
> 
> I can't test my own device at the moment.
> 

Hi Simon,

I would be surprised if this fixes the RT2070L chipset, but it is a
small step in the right direction.

My guess is that the RT2070L chipset is a RT3070 combined with a RF2020 in
a single chip. At least that is how my RT2070L device identifies itself.

---
Gertjan.

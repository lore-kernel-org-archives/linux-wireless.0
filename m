Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.238]:19345 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbXHDIJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2007 04:09:02 -0400
Received: by hu-out-0506.google.com with SMTP id 19so639252hue
        for <linux-wireless@vger.kernel.org>; Sat, 04 Aug 2007 01:09:01 -0700 (PDT)
Message-ID: <46B43415.1000808@gmail.com>
Date: Sat, 04 Aug 2007 10:08:53 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org,
	linux-usb-devel@lists.sourceforge.net
Subject: Re: rt2500usb stopped working (vendor request error)
References: <46B1B0AE.7050205@gmail.com> <200708032015.57569.IvDoorn@gmail.com> <f6ca9fed0708031114v49736b2cxd4525cc4c1650c7e@mail.gmail.com> <200708032031.23966.IvDoorn@gmail.com>
In-Reply-To: <200708032031.23966.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Friday 03 August 2007, dragoran wrote:
>   
>> thats what I am using it for....
>>     
>
> I understand, but if you could test the legacy driver
> for any other mode to see if at least the hardware is
> all right.
> Managed and adhoc mode would already give a good
> idea about any possible hardware problems.
>
>   
while testing the lagacy driver I got this messages:
usb 2-2: new high speed USB device using ehci_hcd and address 4
usb 2-2: unable to read config index 0 descriptor/start
usb 2-2: chopping to 0 config(s)
usb 2-2: string descriptor 0 read error: -71
usb 2-2: string descriptor 0 read error: -71
usb 2-2: string descriptor 0 read error: -71
usb 2-2: no configuration chosen from 0 choices
and nothing worked....

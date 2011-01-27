Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46574 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1A0ROq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 12:14:46 -0500
Received: by qwa26 with SMTP id 26so2338672qwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 09:14:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110127164717.7220.qmail@stuge.se>
References: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
	<20110127164717.7220.qmail@stuge.se>
Date: Thu, 27 Jan 2011 18:14:34 +0100
Message-ID: <AANLkTim_m43Dbv8chF4i0i7XeQyAuqSeOjGZ4dRZ8aaC@mail.gmail.com>
Subject: Re: Mini PCIeWiFi card not detected in non-mini adapter
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 27 stycznia 2011 17:47 użytkownik Peter Stuge <peter@stuge.se> napisał:
> Rafał Miłecki wrote:
>> I've received mini PCIe adapter to PCIe x1 slot to test notebook cards
>> inserted into PC.  Unfortunately after inserting my Broadcom card to
>> it, it is not detected in "lspci" at all.
>
> Tried the various -A options?
>
> linux-sysfs
> linux-proc
> intel-conf1
> intel-conf2

Yes. First three don't differ, last one gives garbage.


> The BIOS could be causing trouble. If intel-conf1 doesn't work then
> try inserting any working PCIe card into the slot, note the bus:slot
> it gets, and finally reboot with the wifi card and run:
>
> lspci -A intel-conf1 -s bus:slot

Thanks, I'll try that when I get any PCIe card.

-- 
Rafał

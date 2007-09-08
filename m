Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:58851 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbXIHQjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 12:39:17 -0400
Received: by wa-out-1112.google.com with SMTP id v27so933731wah
        for <linux-wireless@vger.kernel.org>; Sat, 08 Sep 2007 09:39:16 -0700 (PDT)
Message-ID: <6b8cef970709080939v42e88426n40b68a3aa85a951f@mail.gmail.com>
Date: Sat, 8 Sep 2007 12:39:15 -0400
From: "Rob Hussey" <robjhussey@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Kernel panic with rt2500pci built-in
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709081816.10143.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <1189244217.4506.16.camel@johannes.berg>
	 <6b8cef970709080857s69c055f2s1bc1ce6bd0ad4dfd@mail.gmail.com>
	 <200709081816.10143.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/8/07, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>
> And there was no rt2x00lib, rt2x00pci or rt2500pci error message
> in the log that could indicate why the device is not present?

Not in the log, but on the screen. I should've noticed not everything
was in there. Here's what shows up:

wmaster0: Failed to select rate control algorithm
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
ACPI: PCI interrupt for device 0000:02:0a.0 disabled
rt2500pci: probe of 0000:02:0a.0 failed with error -2

> Could you compile rt2x00 with debug enabled and see what additional
> messages are being printed out?

The above is with debug enabled, and I yesterday I attached dmesg
output with rt2x00 built as modules and debug enabled.

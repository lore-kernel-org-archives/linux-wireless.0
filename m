Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32800 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab0JaPDw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Oct 2010 11:03:52 -0400
Received: by vws13 with SMTP id 13so2468163vws.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Oct 2010 08:03:51 -0700 (PDT)
Message-ID: <4CCD856E.9010006@lwfinger.net>
Date: Sun, 31 Oct 2010 10:04:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek rtl8188 support?
References: <699923.49894.qm@web56805.mail.re3.yahoo.com>
In-Reply-To: <699923.49894.qm@web56805.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2010 06:30 AM, Walter Goldens wrote:
>> Perhaps not, but I want to have one that works before
>> removing the staging driver.
>>
>> I think Realtek is serious. After the r8712u driver was
>> ready for inclusion in
>> staging, I sent them a copy of my revisions to their code.
>> Obviously, they
>> studied it. When I received the new code for a
>> mac80211-based driver for the
>> RTL8192CE driver, it was pretty clean and the sort of
>> changes that were needed
>> for the 8712 had already been done. After only a few hours
>> work, the sparse and
>> checkpatch warnings and errors were fixed. As far as I can
>> tell, this code is
> 
>   By "this code" you mean the code for the PCI chips or the USB ones? This topic here mostly touches on the USB cards, which is why I'm asking. And does that mean you'll include the driver once you've tested the cards?

I mean the PCIe devices. I plan to submit that driver in time to make the 2.6.38
merge. Realtek has not yet sent me the code for the USB devices, but as the chip
and core code is common, it should not be far behind.

Larry


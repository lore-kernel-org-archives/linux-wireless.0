Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45197 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab0LPOKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 09:10:35 -0500
Received: by vws16 with SMTP id 16so1292712vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 06:10:34 -0800 (PST)
Message-ID: <4D0A1DD6.8050500@lwfinger.net>
Date: Thu, 16 Dec 2010 08:10:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek rtl8188 support?
References: <955019.64728.qm@web56808.mail.re3.yahoo.com>
In-Reply-To: <955019.64728.qm@web56808.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2010 07:25 AM, Walter Goldens wrote:
> Realtek has not yet sent me the code for the USB
>> devices, but as the chip
>> and core code is common, it should not be far behind.

> Hey Larry,
> 
> Whats the status quo for the USB driver?

Realtek is still testing/finishing. They sent me the firmware, which I pushed to
linux-firmware, thus that part is ready.

As we just got the code for the PCIe version into wireless-testing yesterday, I
hope that the good news on it will help the USB effort.

Larry


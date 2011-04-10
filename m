Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62737 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab1DJVqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 17:46:50 -0400
Received: by wwa36 with SMTP id 36so5968879wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 14:46:48 -0700 (PDT)
Message-ID: <4DA22545.6050209@gmail.com>
Date: Sun, 10 Apr 2011 23:46:45 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: Firmware files for Ralink RT28x0
References: <4DA2042A.3010301@gmail.com> <1302469406.5282.341.camel@localhost>
In-Reply-To: <1302469406.5282.341.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2011 11:03 PM, Ben Hutchings wrote:

> These files aren't used by the Ralink drivers.  So why should you
> believe the labels on them?

Because the hardware manufacturer says that:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-March/003380.html

Anyway, the firmware in staging(or ralink web) drivers look different because
they are different _versions_ of the _same_ firmware.

rt2870.bin: before 4096 bytes, now 8192 bytes.

> linux-firmware is not *actively* maintained; it requires people to send
> submissions (repeatedly...).

On 04/06/2010, *ONE YEAR AGO* , I sent a patch to rt2870.bin rt2860.bin.
It went to /dev/null

A similar patch was sent by the *driver maintainer* on 10/30/2010.
It went to /dev/null

The same patch was sent by the *hardware manufacturer* on 03/11/2011
It went to /dev/null

Torvalds, Mozart and God are pending.

> I think there may be a problem with distribution of Intel Pro Wireless
> firmware because Intel requires users to accept a EULA.

If it's included in Fedora then there are zero issues with licenses.

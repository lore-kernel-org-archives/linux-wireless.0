Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60304 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab1CSJor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 05:44:47 -0400
Received: by wya21 with SMTP id 21so4526973wya.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Mar 2011 02:44:46 -0700 (PDT)
Message-ID: <4D847B0D.3070502@voltaelectronics.com>
Date: Sat, 19 Mar 2011 10:44:45 +0100
From: Stefano Davolio - Volta Electronics
	<s.davolio@voltaelectronics.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jacopo Mondi <j.mondi@voltaelectronics.com>
Subject: Is setting tx power effective on ar9170?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

we are developing a custom device based on an ar9170 atheros
chipset.
We use ar9170usb driver from linux-omap-2.6.36, but we are experiencing
problems setting the device txpower.
Changing txpower seems to not have any effect on the received signal (on the router).
Can someone confirm that this feature is currently implemented and
working in ar9170usb driver (we use the one-stage firmware, we also
tried the open source firmware version, nothing changed).

Do you suggest using new carl9170? Is the tx power setting implemented
in the new version?


Thank you, we hope you can help us.

  Stefano Davolio


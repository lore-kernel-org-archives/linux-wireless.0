Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay01.ispgateway.de ([80.67.31.24]:59218 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaEDOqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2014 10:46:35 -0400
Received: from [87.185.83.149] (helo=zarafa)
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <stefan.bauer@cubewerk.de>)
	id 1WgxgX-0006qX-4l
	for linux-wireless@vger.kernel.org; Sun, 04 May 2014 16:46:33 +0200
Received: from srv1.localhost (unknown [IPv6:::1])
	by zarafa (Postfix) with ESMTP id 89CEF2202FE
	for <linux-wireless@vger.kernel.org>; Sun,  4 May 2014 16:46:32 +0200 (CEST)
Subject: Issue with monitor mode - iwlwifi - 7260 rev 73 - Microcode SW error
From: =?utf-8?Q?Stefan_Bauer?= <stefan.bauer@cubewerk.de>
To: undisclosed-recipients:;
Cc: =?utf-8?Q?linux-wireless=40vger=2Ekernel=2Eorg?=
	<linux-wireless@vger.kernel.org>
Date: Sun, 4 May 2014 16:46:32 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.536652c8.0ad7.7f837375389ced02@srv1.localhost> (sfid-20140504_164638_155965_E4BBB002)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

I would greatly appreciate it, if you could open it for me please. I assume you are familiar with the required details.

Thank you!

Stefan


-------- Ursprüngliche Nachricht --------
Von: Emmanuel Grumbach 
Datum:04.05.2014 14:00 (GMT+01:00) 
An: Stefan Bauer 
Cc: linux-wireless@vger.kernel.org 
Betreff: Re: Issue with monitor mode - iwlwifi - 7260 rev 73 - Microcode SW error 



On Sun, May 4, 2014 at 1:59 AM, Stefan Bauer <stefan.bauer@cubewerk.de> wrote:
> Dear Developers,
>
> after putting the card into monitor mode with airmon-ng start wlan0 i see instantly a Microcode SW error.
> From time to time, i can also produce a kernel oops.
>
> Hardware is a IBM/Lenovo S440 Laptop with
> Intel 7260 rev73 wlan card
> Kernel is 3.13.10-1
> Lenovo-Laptop-Bios is latest from lenovo webpage
> IWLWIFI Firmware is 22.24.8
>

Ok - this is surely a firmware bug.
Would you be able to open a bugzilla.kernel.org ticket for that?
I an open it for you if needed.
If you do open a ticket, please CC ilw@linux.intel.com to the bug.

Thank you.

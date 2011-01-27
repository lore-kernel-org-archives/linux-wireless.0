Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wipro-blr-out01.wipro.com ([203.91.198.74]:29496 "EHLO
	wipro-blr-out01.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1A0NbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:31:14 -0500
From: <raghunathan.kailasanathan@wipro.com>
To: <linux-wireless@vger.kernel.org>
Date: Thu, 27 Jan 2011 19:01:07 +0530
Subject: unable to put RTL8192SU in master mode
Message-ID: <6D6CA94E9F944C45ABD35E9F7E1CAE619BBF56D579@BLR-SJP-MB02.wipro.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,
I have a USB dongle with realtek 8192SU wireless chipset and am using the 8712u linux driver.

Since this driver is not mac80211 compliant I am using iwconfig to change the mode to "master". Though this
command successfully changes the mode I am unable to connect to this AP from another station, even using
unsecured method. It does not even show up in the station scan list.  Are there some other params I need to 
set using iwconfig ?

Or is the 8712u driver not supporting master mode "sufficiently" enough ?...in which case is some latest
driver available for this thing?

Thanks
RK

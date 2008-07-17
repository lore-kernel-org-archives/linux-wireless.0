Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ctb-mesg4.saix.net ([196.25.240.74]:36885 "EHLO
	ctb-mesg4.saix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbYGQXBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 19:01:16 -0400
Received: from atlantis.local.uls.co.za (dsl-146-147-234.telkomadsl.co.za [165.146.147.234])
	by ctb-mesg4.saix.net (Postfix) with ESMTP id B6781460D
	for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 00:13:59 +0200 (SAST)
Received: from [192.168.0.127]
	by atlantis with esmtpa (Exim 4.69)
	(envelope-from <jaco@kroon.co.za>)
	id 1KJbjb-0002fK-8p
	for linux-wireless@vger.kernel.org; Fri, 18 Jul 2008 00:13:59 +0200
Message-ID: <487FC561.3060104@kroon.co.za> (sfid-20080718_010121_071923_F92A9855)
Date: Fri, 18 Jul 2008 00:19:13 +0200
From: Jaco Kroon <jaco@kroon.co.za>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Subject: AR242x wireless card (ath5k)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've got a Toshiba Satellite 1i4 (P200 derivative) laptop with the 
following wireless card:

05:00.0 Ethernet controller: Atheros Communications Inc. AR242x 
802.11abg Wireless PCI Express Adapter (rev 01)

According to 
http://linuxwireless.org/en/users/Drivers/ath5k#supportedchips the 
module loads but there is no rx/tx - and this is in line with what I see 
with the newly released 2.6.26 kernel (x86_64).

What I would like to know is how I can assist?  I've got a little bit of 
kernel coding experience and my C is at least reasonable.  I don't have 
an abundance of time available but can probably nip in a couple of hours 
worth of work on this.

Regards,
Jaco Kroon

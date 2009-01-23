Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:33250 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZAWS6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:58:09 -0500
Received: by ewy13 with SMTP id 13so3907155ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 10:58:07 -0800 (PST)
Message-Id: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> (sfid-20090123_195815_623277_F89DAAA0)
From: Antonio Marques <froz@icix.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: rt2x00 mesh support
Date: Fri, 23 Jan 2009 18:58:04 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have been trying to setup a mesh network using the 802.11s stack, but
unfortunately the only hardware that I have readily available are rt2x00
usb dongles and an ath5k mini-pci card. Since support for rt2x00
driver is listed on o11s.org as being in development, what is the  
current status
of mesh support for this driver?

I see recent commit activity such as  
fdc26201323eb8ba543ac5624f8d71e55b6f7352,
"rt2x00: Add mesh support" but I am still unable to establish mesh  
links using
rt2x00 devices. An rt2x00 device can see the ath5k device according to
'iw dev mesh station dump', but the link state never changes to ESTAB.

Thanks,
Antonio Marques



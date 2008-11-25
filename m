Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55807 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYKYFcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 00:32:20 -0500
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-Id: <EBB1336F-91C9-4ED6-B663-A1C83FF4A35D@holtmann.org> (sfid-20081125_063224_604538_757C8093)
From: Marcel Holtmann <marcel@holtmann.org>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
In-Reply-To: <492B833E.6050202@atheros.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: Bluetooth is active on the channel where wifi  is also active
Date: Tue, 25 Nov 2008 06:31:48 +0100
References: <492B833E.6050202@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasanth,

> I'm seeing a weird behavior with Broadcom blue tooth chip where it  
> does not seem to skip
> the channel which is currently used by WLAN. I'm using 2.6.27-rc8- 
> wl, is there any configuration
> that i'm missing?

if you have an active Bluetooth connection, then you can check with  
hcitool afh for the actual current channel mapping. Also hciconfig  
hci0 afhmode shows it AFH is actually enabled or (should be by default).

And please remember that AFH is only active connection. When talking  
about inquiry then there is no such thing.

Regards

Marcel


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:14187 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYBRHYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 02:24:16 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1386779fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 23:24:14 -0800 (PST)
Message-ID: <47B93277.5030304@gmail.com> (sfid-20080218_072431_123278_D5DD9738)
Date: Mon, 18 Feb 2008 08:23:35 +0100
From: Ronald <ronald645@gmail.com>
Reply-To: ronald645@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [BUG?] b43: Wireless signal lowers when increasing sound
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hey,

I'm currently using the b43 driver for my BCM4311 chipset. The driver 
works extremely well. It is the only option under Linux that supports 
WPA-AES with wpa_supplicant :) (and it's more stable than 
wpa_supplicant). However, I'm seeing some unexpected behaviour with the 
card and another chipset. When I enable my soundcard (setting volume 
from 0 to > 0) the wireless signal seems to drop completely (really 
funny to see my downloadspeeds go up and down :) ). My question is, is 
this normal?

However, I'm not sure if this is related to the b43 driver so don't 
flame me ;)

						TIA, Ronald

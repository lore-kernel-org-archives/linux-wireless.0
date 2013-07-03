Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44455 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab3GCIhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 04:37:34 -0400
Message-ID: <51D3E2C7.7020605@kaiwen.me> (sfid-20130703_103739_192803_A1A342FD)
Date: Wed, 03 Jul 2013 10:37:27 +0200
From: =?ISO-8859-1?Q?K=E9vin_THIERRY?= <kevin.thierry@kaiwen.me>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ronan lanoe <ronan.lanoe@gmail.com>
Subject: Use of 5GHz frequencies with Wi-Fi Direct
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Is there a way to force the use of 5GHz frequencies with Wi-Fi Direct ? 
(Or define the 5GHz frequencies as preferred ?)

I tried to add the freq_list option in wpa_supplicant config file 
without success. (I think this option should be set in a network block 
but there is no network block for Wi-Fi Direct...)
"freq_list=5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560 
5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825"

Thanks,

Kevin

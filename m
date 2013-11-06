Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wp242.webpack.hosteurope.de ([80.237.133.11]:45459 "EHLO
	wp242.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027Ab3KFHIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 02:08:45 -0500
Message-ID: <5279E615.4000405@Mr-Signal.de> (sfid-20131106_080852_301933_86951454)
Date: Wed, 06 Nov 2013 07:47:49 +0100
From: Norbert Bierhals <Norbert.Bierhals@Mr-Signal.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i will my use my raspberry pi & hostapd for creating a wifi hot spot.
The configuration for set the wifi card in the station mode works fine.

For further tests i will manipulate some of the management frame 
information elements.
The table 8-54 on site 474 in the IEEE802.11-2012 shows all kinds of 
information elements.
Each element got his own ID.

Is it possible to write in each element id and send them over the beacon?

Thanks for your help,
bert.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:60216 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbXLJUk0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 15:40:26 -0500
Received: from randymail-a10.g.dreamhost.com (mailbigip.dreamhost.com [208.97.132.5])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 6792F178E0C
	for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 12:40:25 -0800 (PST)
Received: from [192.168.0.242] (unknown [68.40.216.125])
	by randymail-a10.g.dreamhost.com (Postfix) with ESMTP id 3E8FC10F842
	for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 12:38:14 -0800 (PST)
Message-ID: <475DA27F.2040004@nostar.net> (sfid-20071210_204031_389547_EE3C67EE)
Date: Mon, 10 Dec 2007 15:33:03 -0500
From: Doug McLain <doug@nostar.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problems with b43 using BCM4306 r3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an emachines M6805 with the BCM4306 r3 wifi chip.  Using the
ndiswrapper driver, all is ok, but using the b43 driver results in
constant flow of dmesg output (see link), eventual lockup of wifi under
heavy network traffic, and constant xruns when using JACK audio server.
  Again, when I use the ndiswrapper driver, everything works ok.

http://nostar.net/ardour/dmesg.txt


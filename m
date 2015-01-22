Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta8.messagelabs.com ([216.82.243.194]:60578 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753906AbbAVXnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 18:43:23 -0500
Message-ID: <54C18987.4080805@netcommwireless.com> (sfid-20150123_004326_839497_D74AC94E)
Date: Fri, 23 Jan 2015 10:36:39 +1100
From: Sourav <sourav.chakraborty@netcommwireless.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: iw wlan0 set txpower ...does not work using rt2x00 drivers
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
I am using rt2x00 drivers for RT3072 chipset.......for changing tx 
power, I am issuing "iw wlan0 set txpower fixed <value>".....The command 
succeeds(no error from command line).
However the driver is not setting the value of the txpower....can you 
explain the logic of tx power setting by the driver and how to verify 
the change in txpower?

-- 
Warm Regards,
Sourav


______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________

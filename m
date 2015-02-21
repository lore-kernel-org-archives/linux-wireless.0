Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37323 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbbBURct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2015 12:32:49 -0500
Received: from [50.34.201.20] (unknown [50.34.201.20])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 750C640A539
	for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2015 09:32:48 -0800 (PST)
Message-ID: <54E8C140.1030500@candelatech.com> (sfid-20150221_183253_748397_D1B33184)
Date: Sat, 21 Feb 2015 09:32:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: CT ath10k firmware 10.1.467-13 is released.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are the highlights:

Add IBSS/AHDOC support.
Work-around tx-credits hang due to WMI/CE lockup in firmware (requires ath10k driver patches)
Attempt to fix a few asserts reported by users (scan code, rate-ctrl, resource-mgr, etc)

Known bugs:
CE transport failure assert (Only seen on IMX6 hardware at this time)
WMI keepalive failure, probably due to inability to send mgt frames in bad RF environment.


Downloads and more info is here:

http://www.candelatech.com/ath10k.php

As always, I am interested to hear of users having success or otherwise with
this firmware.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

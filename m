Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:56649 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab1EELVa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 07:21:30 -0400
Subject: wireless-regdb US and CA settings incorrect?
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 14:21:18 +0300
Message-ID: <1304594478.3749.61.camel@wimaxnb> (sfid-20110505_132134_114265_ADBF198E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John, all,

The following is an excerpt of the db.txt from most recent
wireless-regdb.

country US:
         (2402 - 2472 @ 40), (3, 27)
         (5170 - 5250 @ 40), (3, 17)
         (5250 - 5330 @ 40), (3, 20), DFS
         (5490 - 5600 @ 40), (3, 20), DFS
         (5650 - 5710 @ 40), (3, 20), DFS
         (5735 - 5835 @ 40), (3, 30)
 
country CA:
         (2402 - 2472 @ 40), (3, 27)
         (5170 - 5250 @ 40), (3, 17)
         (5250 - 5330 @ 40), (3, 20), DFS
         (5490 - 5710 @ 40), (3, 20), DFS
         (5735 - 5835 @ 40), (3, 30)

We are under the understanding that the Canadian national rules deny the
usage of the 5490-5710 range of frequencies (ref from RSS-210), but the
range is present in the allowed range of frequencies for the CA region:

"Additional requirements for the band 5600-5650 MHz: Until further
notice, devices subject to this Section shall not be capable of
transmitting in the band 5600-5650 MHz, so that Environment Canada
weather radars operating in this band are protected."

Then again, the FCC rules (15.407) do not prohibit the mentioned range
of frequencies within the US (with DFS and limited power level) but in
the regulatory database that range is missing.


Is there a bug in the regulatory db, or am I misunderstanding something?


-Juuso


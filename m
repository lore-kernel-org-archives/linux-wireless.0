Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:56677 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbcCaOAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 10:00:25 -0400
From: DINO MYCLE <dino.mycle@sasken.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Chayan Biswas <chayan.biswas@sasken.com>
Subject: WL1271 Sending Tx Pkt using calibrator
Date: Thu, 31 Mar 2016 14:00:15 +0000
Message-ID: <e523028d-e55d-46ce-849d-fb359b6e412e@EXGHTSFZ01.sasken.com> (sfid-20160331_160028_387343_7FA242A3)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello All,

We are trying use the calibrator for sending Tx packet for testing. Based on the wiki http://processors.wiki.ti.com/index.php/WL127x_TX_Testing

we want to send MCS0 - MCS7 frames, when we tried using the following commands, MCS0-MCS7 frmaes alone is not coming  with preamble set to 6/7 are we missing some configuration? can someone help me

calibrator wlan0 plt power_mode on
calibrator wlan0 plt tune_channel 0 1
calibrator wlan0 plt tx_cont 2000 0x2000 1500  0 17000 10000 3 1 0 6 3 1 1 1 08:00:12:34:56:7a calibrator wlan0 plt tx_stop calibrator wlan0 plt power_mode off


thanks for the support
--
Dino Joseph Mycle

________________________________

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html

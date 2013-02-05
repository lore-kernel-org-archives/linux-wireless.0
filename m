Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snvl-smtp1.trimble.com ([155.63.64.31]:33302 "EHLO
	snvl-smtp1.trimble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3BETGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 14:06:24 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: Regulatory Database incorrect for US (FCC)
Date: Tue, 5 Feb 2013 11:59:41 -0700
Message-ID: <C77C279BA71FD14985DC8E75FB265AB70E0A0B31@usw-am-xch-02.am.trimblecorp.net> (sfid-20130205_200628_334307_C85E1C49)
From: "Ian Welch" <ian_welch@trimble.com>
To: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Cc: "Max Collins" <max_collins@trimble.com>,
	"David Bird" <David_Bird@Trimble.com>,
	"Geoffrey Kirk" <Geoffrey_Kirk@Trimble.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
	The most recent version of the wireless-regdb has incorrect
antenna gain and conducted power parameters for operation in the US. The
parameters called out in the regdb file for country US: are 3dBi peak
antenna gain and 27dBm conducted power "(2402 - 2472 @ 40), (3, 27)".
Per FCC Part 15.247 paragraph (b)(3) the peak output power should be 1W
and according to section (b)(4) the peak antenna gain should be 6dBi.  I
would like to know why 3dBi and 27dBm were selected and propose that
these be change to 6dBi and 30dBm respectively. 


-Link to regdb file:
http://kernel.org/pub/software/network/wireless-regdb/wireless-regdb-201
3.01.11.tar.gz


-Link to FCC Part 15.247
http://www.ecfr.gov/cgi-bin/text-idx?c=ecfr&SID=4d6c95d3919126f0773ed7d1
94eb4932&rgn=div8&view=text&node=47:1.0.1.1.16.3.234.31&idno=47


====FCC Part 15.247====
(b) The maximum peak conducted output power of the intentional radiator
shall not exceed the following:

(1) For frequency hopping systems operating in the 2400-2483.5 MHz band
employing at least 75 non-overlapping hopping channels, and all
frequency hopping systems in the 5725-5850 MHz band: 1 watt. For all
other frequency hopping systems in the 2400-2483.5 MHz band: 0.125
watts.

(2) For frequency hopping systems operating in the 902-928 MHz band: 1
watt for systems employing at least 50 hopping channels; and, 0.25 watts
for systems employing less than 50 hopping channels, but at least 25
hopping channels, as permitted under paragraph (a)(1)(i) of this
section.

(3) For systems using digital modulation in the 902-928 MHz, 2400-2483.5
MHz, and 5725-5850 MHz bands: 1 Watt. As an alternative to a peak power
measurement, compliance with the one Watt limit can be based on a
measurement of the maximum conducted output power. Maximum Conducted
Output Power is defined as the total transmit power delivered to all
antennas and antenna elements averaged across all symbols in the
signaling alphabet when the transmitter is operating at its maximum
power control level. Power must be summed across all antennas and
antenna elements. The average must not include any time intervals during
which the transmitter is off or is transmitting at a reduced power
level. If multiple modes of operation are possible (e.g., alternative
modulation methods), the maximum conducted output power is the highest
total transmit power occurring in any mode.

(4) The conducted output power limit specified in paragraph (b) of this
section is based on the use of antennas with directional gains that do
not exceed 6 dBi. Except as shown in paragraph (c) of this section, if
transmitting antennas of directional gain greater than 6 dBi are used,
the conducted output power from the intentional radiator shall be
reduced below the stated values in paragraphs (b)(1), (b)(2), and (b)(3)
of this section, as appropriate, by the amount in dB that the
directional gain of the antenna exceeds 6 dBi.

(i) Systems operating in the 2400-2483.5 MHz band that are used
exclusively for fixed, point-to-point operations may employ transmitting
antennas with directional gain greater than 6 dBi provided the maximum
peak output power of the intentional radiator is reduced by 1 dB for
every 3 dB that the directional gain of the antenna exceeds 6 dBi.

(ii) Systems operating in the 5725-5850 MHz band that are used
exclusively for fixed, point-to-point operations may employ transmitting
antennas with directional gain greater than 6 dBi without any
corresponding reduction in transmitter peak output power.

(iii) Fixed, point-to-point operation, as used in paragraphs (b)(3)(i)
and (b)(3)(ii) of this section, excludes the use of point-to-multipoint
systems, omnidirectional applications, and multiple co-located
intentional radiators transmitting the same information. The operator of
the spread spectrum intentional radiator or, if the equipment is
professionally installed, the installer is responsible for ensuring that
the system is used exclusively for fixed, point-to-point operations. The
instruction manual furnished with the intentional radiator shall contain
language in the installation instructions informing the operator and the
installer of this responsibility.

	


Ian Welch 
10355 Westmoor Dr.
Westminster, CO 80021



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wn1-mbie.dmzglobal.net ([203.144.33.76]:29012 "EHLO
	wn1-mbie.dmzglobal.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaJ1BOB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 21:14:01 -0400
From: Peter Gent <Peter.Gent@mbie.govt.nz>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wireless-regdb: Update regulatory rules for New Zealand (NZ) on
 5GHz and 60 GHz [UNCLASSIFIED]
Date: Tue, 28 Oct 2014 01:04:10 +0000
Message-ID: <D0D2EC853BFD0147A005CC7FAC0E4A53E39A56A6@AKI2K113.wd.govt.nz> (sfid-20141028_021406_004407_3B0940E3)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We wish to note the following changes should be made to the wireless regulatory database to reflect some recent changes to the 60 GHz band here in New Zealand. In additional there are some inaccuracies when compared to our current licencing for the 5 GHz "Wi-Fi" band.

The updated entry for New Zealand should read:

5150 MHz  - 5250 MHz  80MHz channels, indoor use only at -7.0 dBW EIRP TPC enabled
5250 MHz -  5350 MHz  80 MHz channels, indoor use at -7.0 dBW EIRP, outdoor use at 0 dBW EIRP with DFS and TPC enabled* 
5470 MHz  - 5725 MHz  80 MHz channels, 0 dBW EIRP with DFS and TPC enabled*
5725 MHz  - 5875 MHz  80 MHz channels, 6.0 dBW EIRP with frequency hopping enabled  
57000 MHz - 66000 MHz, indoor use only at 13.0 dBW EIRP 

*if TPC is not enabled, than transmit power must be reduced by 3dB

Further information on SRD licencing rules can be found at http://www.rsm.govt.nz/cms/licensees/types-of-licence/general-user-licences/short-range-devices 

Regards

Peter




Peter Gent
PLANNING ANALYST

Radio Spectrum Management, Infrastructure & Resource Markets Group
Ministry of Business, Innovation & Employment

peter.gent@mbie.govt.nz | DDI:  +64 4 462 4279  |  Ext 44279  
Free Phone: 0508 RSM INFO (776 463) | Website: www.rsm.govt.nz 
15 Stout Street, PO Box 2847, Wellington, New Zealand





newzealand.govt.nz - connecting you to New Zealand central & local government services

Any opinions expressed in this message are not necessarily those of the Ministry of Business, Innovation and Employment. This message and any files transmitted with it are confidential and solely for the use of the intended recipient. If you are not the intended recipient or the person responsible for delivery to the intended recipient, be advised that you have received this message in error and that any use is strictly prohibited. Please contact the sender and delete the message and any attachment from your computer.


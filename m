Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp156.iad.emailsrvr.com ([207.97.245.156]:41530 "EHLO
	smtp156.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXFIDvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 23:51:15 -0400
Message-ID: <466A2383.50001@gentoo.org>
Date: Fri, 08 Jun 2007 23:50:27 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: Regulatory info in mac80211
References: <4665CCE7.5090409@lwfinger.net>
In-Reply-To: <4665CCE7.5090409@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> 5. There should be a scheme for translating country codes based on the 
> outdated table 105 in Corrigendum 1 for 802.11b. This is the basis for 
> the EEPROM data in the ZD1211 hardware. Note, this scheme is far too 
> limited to be the only one available. If the translation code is needed 
> for more than one driver, it should be placed in mac80211.

You might wish to treat the fact that the ZD1211 EEPROM regdomain field 
appears to correspond to the 802.11b specs as just a coincidence. Some 
newer devices have regdomain values that are not in that table (and are 
not even mentioned in the vendor driver...)

Daniel

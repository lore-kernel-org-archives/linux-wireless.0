Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42204 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763334AbXFKCoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2007 22:44:08 -0400
Message-ID: <466CB6F6.1020706@lwfinger.net>
Date: Sun, 10 Jun 2007 21:44:07 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: Regulatory info in mac80211
References: <4665CCE7.5090409@lwfinger.net> <466A2383.50001@gentoo.org>
In-Reply-To: <466A2383.50001@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:
> Larry Finger wrote:
>> 5. There should be a scheme for translating country codes based on the 
>> outdated table 105 in Corrigendum 1 for 802.11b. This is the basis for 
>> the EEPROM data in the ZD1211 hardware. Note, this scheme is far too 
>> limited to be the only one available. If the translation code is 
>> needed for more than one driver, it should be placed in mac80211.
> 
> You might wish to treat the fact that the ZD1211 EEPROM regdomain field 
> appears to correspond to the 802.11b specs as just a coincidence. Some 
> newer devices have regdomain values that are not in that table (and are 
> not even mentioned in the vendor driver...)

That was my intent from the start. The two European countries (France and Spain) that are mentioned 
in that table have the wrong channels assigned; however, if some driver asked for either of those 
regions, we will supply the channel data that is current today.

Larry

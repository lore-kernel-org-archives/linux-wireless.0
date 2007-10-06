Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from probity.mcc.ac.uk ([130.88.200.94]:60578 "EHLO
	probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbXJFRtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 13:49:08 -0400
Message-ID: <4707CA7F.6030609@gentoo.org> (sfid-20071006_184914_033579_1B50D204)
Date: Sat, 06 Oct 2007 18:48:47 +0100
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Greg Johnson <gregfjohnson@yahoo.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: usb wifi ad-hoc mode suggestions?
References: <371947.67660.qm@web33501.mail.mud.yahoo.com>
In-Reply-To: <371947.67660.qm@web33501.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg Johnson wrote:
> We're trying the zd1211 with the zd1211rw driver and the mac80211 stack,
> which doesn't seem to have ad-hoc support currently, but their web site says
> it should be easy to add.

If you have coding resources on your hands, all that needs to be done is 
for someone to look at the ad-hoc handling code in the vendor driver and 
port it over the mac80211 driver. Diving into the vendor driver is a bit 
of a challenge though.

Daniel


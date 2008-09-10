Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40590 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbYIJRWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 13:22:10 -0400
Message-ID: <48C80241.4000409@lwfinger.net> (sfid-20080910_192214_882590_8D4DF454)
Date: Wed, 10 Sep 2008 12:22:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: furlot@free.fr
Subject: Compaq laptop RFKILL problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to help a Ubuntu user get his BCM4303 working on a Compaq 
Presario R3215. His radio is hardware disabled, but the RFKILL switch 
does not issue a scancode when pushed. Obviously, the Windows software 
polls that key in some manner, but we have no idea what it does.

So far, we have updated the RFKILL level to that of wireless-testing, 
tried a BIOS reset, and modified the code to issue a KEY_WLAN down/up 
sequence when starting. So far, nothing has worked.

Does anyone on this list know of anything else to try, or any software 
to handle this button?

Thanks,

Larry


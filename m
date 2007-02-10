Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59682 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbXBJUeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 15:34:03 -0500
Message-ID: <45CE2C2F.8070502@lwfinger.net>
Date: Sat, 10 Feb 2007 14:33:51 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702091753.12419.mb@bu3sch.de> <200702101811.37355.rjw@sisk.pl>
In-Reply-To: <200702101811.37355.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael,

Rafael J. Wysocki wrote:
> 
> I'm running with this patch applied right now, but the association is lost
> after the resume anyway.  I have to reload bcm43xx to make it associate with
> the AP again (no big deal).


Please send me the output of iwconfig and ifconfig after the resume, but before you reload bcm43xx.

Will the interface recover with any measure less drastic than reloading? Does an ifdown/ifup
sequence do the trick?

Thanks,

Larry

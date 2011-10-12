Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3719 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab1JLOTM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 10:19:12 -0400
Message-ID: <4E95A1D1.8010602@broadcom.com> (sfid-20111012_161916_290984_BF449543)
Date: Wed, 12 Oct 2011 16:18:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "gregkh@suse.de" <gregkh@suse.de>
cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] staging: brcm80211: remove brcm80211 driver from the
 staging tree
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

John recommended to do the delete through your staging tree. Thanks for
the ride. It has been a learning experience for all of us here. Apart
from the significant cleanup (which needs ongoing work for sure) it took
some time to find the right way of working in coordinating our changes
with community patches.

The removal patch was just as big as the mainline patch so it has been
uploaded to linuxwireless.org:

http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=view&target=0001-staging-brcm80211-remove-brcm80211-driver-from-the-s.patch

Regards,
Arend van Spriel


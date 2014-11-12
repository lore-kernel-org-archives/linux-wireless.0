Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43655 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbaKLOfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 09:35:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XoZ0h-0001tW-WF
	for linux-wireless@vger.kernel.org; Wed, 12 Nov 2014 15:35:04 +0100
Received: from 143.129.72.187 ([143.129.72.187])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 15:35:03 +0100
Received: from patrick.d.bosch by 143.129.72.187 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 15:35:03 +0100
To: linux-wireless@vger.kernel.org
From: Patrick Bosch <patrick.d.bosch@gmail.com>
Subject: MAC acl equivalent to iwpriv for nl80211 drivers
Date: Wed, 12 Nov 2014 14:31:12 +0000 (UTC)
Message-ID: <loom.20141112T152857-158@post.gmane.org> (sfid-20141112_153512_863981_13720E9E)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everybody

I hope I do post this in the correct mailing list.

My problem is the following:

I want to add/delete new MAC addresses to the acl without restarting
anything. Without restarting I mean that there shouldn't be a time frame
where no beacon frames are sent. This happened to me on an OpenWRT
router and I want to avoid this effect.

It seems to me that iwpriv offers exactly this functionality. You can add
a list of MAC addresses and define how they should be handled. Iw
doesn't seem to offer this option. Is there any other way to get this
functionality? 

Another question would be, if there is a way to forge management
frames, similar to what hostapd_cli can do for deauthentication and
disassociation frames? 

Any help is appreciated!

Kind regards
Patrick



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51947 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbbEBRHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2015 13:07:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Yoat7-00026d-9G
	for linux-wireless@vger.kernel.org; Sat, 02 May 2015 19:07:37 +0200
Received: from md-188-69-194-165.omni.lt ([188.69.194.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2015 19:07:37 +0200
Received: from nerijus by md-188-69-194-165.omni.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 02 May 2015 19:07:37 +0200
To: linux-wireless@vger.kernel.org
From: Nerijus =?utf-8?b?QmFsacWrbmFz?= <nerijus@users.sourceforge.net>
Subject: Re: b43 AP does not work
Date: Sat, 2 May 2015 17:07:29 +0000 (UTC)
Message-ID: <loom.20150502T190504-905@post.gmane.org> (sfid-20150502_190742_069224_8A2517BE)
References: <loom.20150502T183011-57@post.gmane.org> <5544FFE5.5090706@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> A resource busy error from nl80211 usually means that NetworkManager is 
> controlling the interface. Are you using NM? If so, have you tried setting
up an 
> AP using the "access point" mode of the NM applet. That is a lot easier than 
> using hostapd, and has the additional advantage of being able to use wireless 
> cards for both the WAN and LAN sides of the AP.

IIRC I used "access point" mode of the NM applet and it worked, but now I
cannot find such option (at least in MATE). Is it somehow possible to still
use hostapd manually?

Thanks,
Nerijus



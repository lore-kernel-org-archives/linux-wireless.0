Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58141 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbYEDRuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 13:50:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JsiLa-0000Em-SE
	for linux-wireless@vger.kernel.org; Sun, 04 May 2008 17:50:02 +0000
Received: from cpc2-oxfd6-0-0-cust234.oxfd.cable.ntl.com ([86.3.132.235])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 04 May 2008 17:50:02 +0000
Received: from law_ence.dev by cpc2-oxfd6-0-0-cust234.oxfd.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 04 May 2008 17:50:02 +0000
To: linux-wireless@vger.kernel.org
From: ael <law_ence.dev@ntlworld.com>
Subject: iw: NL80211_IFTYPE_MESH_POINT not defined
Date: Sun, 04 May 2008 18:47:04 +0100
Message-ID: <fvksqp$blq$1@ger.gmane.org> (sfid-20080504_194934_131530_1EA0F365)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am not sure that this is the right place to ask, but I am trying to
compile iw and get

interface.c: In function 'get_if_type':
interface.c:50: error: 'NL80211_IFTYPE_MESH_POINT' undeclared (first use
in this function)

I guess that this should be defined in /usr/include/linux/nl80211.h but
it is not present there nor in nl80211.h in kernel 2.6.25.1 which I have
installed.

I checked out iw from  http://git.sipsolutions.net/iw.git

I see NL80211_IFTYPE_MESH_POINT appearing in patches on this list so I
guess it is present in development trees.

I am just trying to get a usb-wifi device running with 2.6.25.x where
the driver has moved to mac80211. iwconfig appears to work no longer and
I found documentation to the effect that iw was required instead. Hence
my attempts to compile it.

Could someone with a moment to spare either point me to some
documentation or a solution? Perhaps iw is not intended for use with
2.6.25.x and the problems with iwconfig lie elsewhere?

A Lawrence


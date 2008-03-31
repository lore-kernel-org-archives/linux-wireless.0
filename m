Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:4020 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbYCaThf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 15:37:35 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1725256wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 12:37:34 -0700 (PDT)
Message-ID: <f6ca9fed0803311237w1b714034w8ba3cfd56aec9686@mail.gmail.com> (sfid-20080331_203738_314043_287A3D62)
Date: Mon, 31 Mar 2008 21:37:34 +0200
From: drago01 <drago01@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: dynamic wep with mulitple keys
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I noticed that I can connect to some dynamic wep APs fine using
iwl3945 and with other it does not work, while ipw3945 work with all
of them.
Both driver associate fine but iwl3945 never gets an ip from dhcp.
I checked with iwlist key and it seems that this APs are using only
one key with iwl3945 but two with ipw3945.
The APs that work (I recognize them by BSSID) are using only one key
with both drivers.
Does this mean that mac80211/iwl3945 for some reason drops one key or
never sets it?  (broadcast key?)
Any idea how to get more infos to debug this? (Can attach both iwlist
key outputs if this is needed).

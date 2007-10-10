Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:6489 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbXJJJp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 05:45:28 -0400
Received: by nf-out-0910.google.com with SMTP id g13so127983nfb
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 02:45:26 -0700 (PDT)
Message-ID: <470C9F28.1070803@gmail.com> (sfid-20071010_104530_168187_5A3128F1)
Date: Wed, 10 Oct 2007 11:45:12 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: mac80211/iwlwifi + hidden ssids
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I am unable to connect to a dynamic wep network with hidden ssid using 
iwl3945 and the lastest fedora 7 kernel (which should have very recent 
stuff). The problem is that the card never finds the ap. Running 
wpa_supplicant directly shows "Got scan results xxx bytes" (can't 
remeber the exact message).
While with ipw3945d + ieee80211 it works fine. (NetworkManager does not 
connect either see http://bugzilla.gnome.org/show_bug.cgi?id=464215 ).
I haven't tryed the suggestion there yet because I am not near the 
network right now.
Any idea whats wrong? Does it work for anybody (maybe with other 
mac80211 drivers)
Currently I am not sure whom to blame iwl3945 or mac80211 or both.


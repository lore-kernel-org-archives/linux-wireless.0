Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40794 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2EVACN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 20:02:13 -0400
Received: by weyu7 with SMTP id u7so3527863wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 17:02:12 -0700 (PDT)
Message-ID: <4FBAD772.2090807@googlemail.com> (sfid-20120522_020217_199302_F20E15A3)
Date: Tue, 22 May 2012 01:01:54 +0100
From: Michael Zintakis <michael.zintakis@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: IEEE 802.11w support/compliance in TI-1251 (wl1251)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

I hope this is the right place to post my query (below), apologies, if 
not. I did try TI's own "support" forum (E2E) as well as emailing TI 
support directly a couple of times, but, let just say that I didn't 
exactly have the best of luck with them...

I have an old-ish smartphone using the above wireless chip and I am 
trying to configure it to use MFP (Management Frame Protection), but I 
am not having much success with this. The smartphone uses TI-s own 
driver (I think it is v4.x of WiLink - the kernel object is called 
wlan.ko, the interface is named tiwlan0).

After banging my head against the wall - multiple times - it was 
suggested to me that this driver may not have support for MFP (IEEE 
802.11w).

I have "forced" MFP on the AP side via ieee80211w=2 (mandatory) and when 
I configure supplicant's configuration file (wpa_supplicant.conf) to get 
into this mode by including "ieee80211w=2" within the network segment of 
that file, on the AP side I get the following error message: "Management 
frame protection required, but client did not enable it".

After several unsuccessful attempts to enforce this option and getting 
in touch with the wpa_supplicant/hostapd software author, I have been 
told that either TI's own driver or the TI-1251 hardware device may not 
have support for this.

Could anyone more experienced/knowledgeable clarify this for me please - 
is there any way I could enforce this and deploy MFP or am I doomed to 
failure?

I am also not completely clear whether I may have more luck if I replace 
the TI's own WiLink driver with the "standard" wireless driver (I 
haven't yet tried to do that, don't know whether this is possible 
either) - provided the WiLink driver does not support MFP.

Thanks in advance for any help!


MZ


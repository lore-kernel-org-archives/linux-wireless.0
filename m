Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56905 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab1EKT3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 15:29:08 -0400
Received: by bwz15 with SMTP id 15so714924bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 12:29:07 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 11 May 2011 14:29:06 -0500
Message-ID: <BANLkTikOw0j8hLBRf6m1p7REpJvNf3mqCw@mail.gmail.com> (sfid-20110511_212926_919551_DA5BA33B)
Subject: rtl8192ce.ko doesn't work with 802.11n?
From: Flaminigo <sunnyiez@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MY university deployed 802.11n wireless LAN. However, my new T420
cannot connect to the network under ubuntu 11.04. I found the driver
for realtek 8188CE is rtl8192ce.ko, rtlwifi. I asked network
administrator to help me. They told me my wireless adapter didn't work
well with the 802.11n network. Is this because of the driver? The
following are the wpa_supplicant output. FYI

------------------
Trying to authenticate with 00:0b:85:97:33:0c (SSID='tamulink-wpa'
freq=2462 MHz)
Trying to associate with 00:0b:85:97:33:0c (SSID='tamulink-wpa' freq=2462 MHz)
Associated with 00:0b:85:97:33:0c
CTRL-EVENT-EAP-STARTED EAP authentication started
CTRL-EVENT-EAP-FAILURE EAP authentication failed
CTRL-EVENT-DISCONNECTED bssid=00:0b:85:97:33:0c reason=7
Authentication with 00:00:00:00:00:00 timed out.
Failed to initiate AP scan.
Trying to authenticate with 00:24:6c:d0:48:42 (SSID='tamulink-wpa'
freq=2462 MHz)
Trying to associate with 00:24:6c:d0:48:42 (SSID='tamulink-wpa' freq=2462 MHz)
Associated with 00:24:6c:d0:48:42
CTRL-EVENT-EAP-STARTED EAP authentication started
CTRL-EVENT-EAP-PROPOSED-METHOD vendor=0 method=26 -> NAK
CTRL-EVENT-EAP-PROPOSED-METHOD vendor=0 method=25
CTRL-EVENT-EAP-METHOD EAP vendor 0 method 25 (PEAP) selected
CTRL-EVENT-EAP-PEER-CERT depth=3 subject='/L=ValiCert Validation
Network/O=ValiCert, Inc./OU=ValiCert Class 2 Policy Validation
Authority/CN=http://www.valicert.com//emailAddress=info@valicert.com'
CTRL-EVENT-EAP-PEER-CERT depth=2 subject='/C=US/O=The Go Daddy Group,
Inc./OU=Go Daddy Class 2 Certification Authority'
CTRL-EVENT-EAP-PEER-CERT depth=1
subject='/C=US/ST=Arizona/L=Scottsdale/O=GoDaddy.com,
Inc./OU=http://certificates.godaddy.com/repository/CN=Go Daddy Secure
Certification Authority/serialNumber=07969287'
CTRL-EVENT-EAP-PEER-CERT depth=0 subject='/O=net.tamu.edu/OU=Domain
Control Validated/CN=net.tamu.edu'
EAP-MSCHAPV2: Authentication succeeded
EAP-TLV: TLV Result - Success - EAP-TLV/Phase2 Completed
CTRL-EVENT-EAP-SUCCESS EAP authentication completed successfully
WPA: Key negotiation completed with 00:24:6c:d0:48:42 [PTK=CCMP GTK=TKIP]
CTRL-EVENT-CONNECTED - Connection to 00:24:6c:d0:48:42 completed
(auth) [id=0 id_str=]
Michael MIC failure detected
WPA: Sending EAPOL-Key Request (error=1 pairwise=0 ptk_set=1 len=99)
Michael MIC failure detected
WPA: Sending EAPOL-Key Request (error=1 pairwise=0 ptk_set=1 len=99)
TKIP countermeasures started
CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=14
^CCTRL-EVENT-TERMINATING - signal 2 received

-- 
Regards
sunny

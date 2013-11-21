Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63320 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab3KUNl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 08:41:29 -0500
Received: by mail-we0-f174.google.com with SMTP id q58so4961010wes.33
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2013 05:41:28 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Nov 2013 19:11:28 +0530
Message-ID: <CADNhdGFPR6JOkZjDMMZ7mEo5cJdBrg9a300A4pS=e_WGMdNpbA@mail.gmail.com> (sfid-20131121_144146_582040_1FEE1D88)
Subject: [hostapd] configuring for a simple AP
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to make a linux PC up and running with hostapd to create a
simple Access Point.

I do not want authentication, encryption and DHCP -- have configured
station with static IP address.

if I start hostapd (not as a daemon) with the default hostapd.conf
file, and try connecting the client (fedora client), i see that the
wifi sybol does not appear, but the connection seems to have been
established.
However, if i open hostapd_cli, i keep getting a print like,
<client mac> CONNECTED
<client mac> DISCONNECTED.

Hence, i think the client keeps getting connected and disconnected.

I then tried using a smaller config file with nothing regarding beacon
interval etc...as shown below:

---
interface=wlan0
driver=nl80211
ssid=test
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
---

The results were similar.

Could anyone, guide me or provide me a simple hostapd.conf file, that
will help me connect clients. I do not want authentication,
encryption, and DHCP -- will use static IP.

Thanks in advance.

-shankar

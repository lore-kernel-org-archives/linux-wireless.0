Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64546 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbaLTAQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 19:16:56 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so2606422wgg.33
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2014 16:16:55 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 20 Dec 2014 00:16:55 +0000
Message-ID: <CACZYS+o80M7OkxUTOumCf1VhPRjM-U0zj8xebGQ8-1W_qPDo5Q@mail.gmail.com> (sfid-20141220_011659_481869_F88C0051)
Subject: nl80211: send_and_recv->nl_recvmsgs failed: -33
From: Notes Jonny <jongmob@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I am seeing this error message quite often in syslog. Was wondering if
it is something I can fix. Not sure if related, but the laptop drops
off the established wifi at this location (that problem happens ever
few days).

Could the -33 be replaced with an error string? I wonder what -33 is,
perhaps -EDOM?

Regards, Jonny

Dec 20 00:07:28 ubuntu1404 NetworkManager[749]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
Dec 20 00:07:28 ubuntu1404 NetworkManager[749]: <info> Activation
(wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
Dec 20 00:07:28 ubuntu1404 wpa_supplicant[1095]: wlan0: CTRL-EVENT-SCAN-STARTED
Dec 20 00:07:29 ubuntu1404 wpa_supplicant[1095]: nl80211:
send_and_recv->nl_recvmsgs failed: -33
Dec 20 00:08:11 ubuntu1404 wpa_supplicant[1095]: wlan0: CTRL-EVENT-SCAN-STARTED
Dec 20 00:08:12 ubuntu1404 wpa_supplicant[1095]: nl80211:
send_and_recv->nl_recvmsgs failed: -33
Dec 20 00:09:14 ubuntu1404 wpa_supplicant[1095]: wlan0: CTRL-EVENT-SCAN-STARTED
Dec 20 00:09:15 ubuntu1404 wpa_supplicant[1095]: nl80211:
send_and_recv->nl_recvmsgs failed: -33
Dec 20 00:09:45 ubuntu1404 wpa_supplicant[1095]: wlan0: WPA: Group
rekeying completed with xxxxxxxxxxxxxx [GTK=TKIP]
Dec 20 00:10:37 ubuntu1404 wpa_supplicant[1095]: wlan0: CTRL-EVENT-SCAN-STARTED
Dec 20 00:10:38 ubuntu1404 wpa_supplicant[1095]: nl80211:
send_and_recv->nl_recvmsgs failed: -33
Dec 20 00:12:20 ubuntu1404 wpa_supplicant[1095]: wlan0: CTRL-EVENT-SCAN-STARTED
Dec 20 00:12:21 ubuntu1404 wpa_supplicant[1095]: nl80211:
send_and_recv->nl_recvmsgs failed: -33

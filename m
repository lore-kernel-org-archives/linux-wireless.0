Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53955 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbASNzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 08:55:03 -0500
Received: by mail-wg0-f44.google.com with SMTP id y19so31893827wgg.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 05:55:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACZYS+qEBf+GfcyQRugc7=3899qdPjQPynj2d+Pi10U3mdM9oA@mail.gmail.com>
References: <CACZYS+o80M7OkxUTOumCf1VhPRjM-U0zj8xebGQ8-1W_qPDo5Q@mail.gmail.com>
	<CACZYS+qEBf+GfcyQRugc7=3899qdPjQPynj2d+Pi10U3mdM9oA@mail.gmail.com>
Date: Mon, 19 Jan 2015 13:55:01 +0000
Message-ID: <CACZYS+piiVRdqCKei+Jvv7p4eCmvGwYvoxjP8gBoVrmQY4fBkg@mail.gmail.com> (sfid-20150119_145515_122585_39033171)
Subject: Re: nl80211: send_and_recv->nl_recvmsgs failed: -33
From: Notes Jonny <jongmob@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

Let me know if anyone would like to look into this.

If it's already solved, let me know so I can unsubscribe...

Regards Jonny


On Tue, Dec 23, 2014 at 12:24 PM, Notes Jonny <jongmob@gmail.com> wrote:
> Hello
>
> Let me know if anyone would like to look into this.
>
> If it's already solved, let me know
>
> Regards Jonny
>
> Hello
>
> I am seeing this error message quite often in syslog. Was wondering if
> it is something I can fix. Not sure if related, but the laptop drops
> off the established wifi at this location (that problem happens ever
> few days).
>
> Could the -33 be replaced with an error string? I wonder what -33 is,
> perhaps -EDOM?
>
> Regards, Jonny
>
> Dec 20 00:07:28 ubuntu1404 NetworkManager[749]: <info> Activation
> (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) started...
> Dec 20 00:07:28 ubuntu1404 NetworkManager[749]: <info> Activation
> (wlan0) Stage 4 of 5 (IPv6 Configure Timeout) complete.
> Dec 20 00:07:28 ubuntu1404 wpa_supplicant[1095]: wlan0:
> CTRL-EVENT-SCAN-STARTED
> Dec 20 00:07:29 ubuntu1404 wpa_supplicant[1095]: nl80211:
> send_and_recv->nl_recvmsgs failed: -33
> Dec 20 00:08:11 ubuntu1404 wpa_supplicant[1095]: wlan0:
> CTRL-EVENT-SCAN-STARTED
> Dec 20 00:08:12 ubuntu1404 wpa_supplicant[1095]: nl80211:
> send_and_recv->nl_recvmsgs failed: -33
> Dec 20 00:09:14 ubuntu1404 wpa_supplicant[1095]: wlan0:
> CTRL-EVENT-SCAN-STARTED
> Dec 20 00:09:15 ubuntu1404 wpa_supplicant[1095]: nl80211:
> send_and_recv->nl_recvmsgs failed: -33
> Dec 20 00:09:45 ubuntu1404 wpa_supplicant[1095]: wlan0: WPA: Group
> rekeying completed with xxxxxxxxxxxxxx [GTK=TKIP]
> Dec 20 00:10:37 ubuntu1404 wpa_supplicant[1095]: wlan0:
> CTRL-EVENT-SCAN-STARTED
> Dec 20 00:10:38 ubuntu1404 wpa_supplicant[1095]: nl80211:
> send_and_recv->nl_recvmsgs failed: -33
> Dec 20 00:12:20 ubuntu1404 wpa_supplicant[1095]: wlan0:
> CTRL-EVENT-SCAN-STARTED
> Dec 20 00:12:21 ubuntu1404 wpa_supplicant[1095]: nl80211:
> send_and_recv->nl_recvmsgs failed: -33

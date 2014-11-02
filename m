Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaKBNDC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2014 08:03:02 -0500
Date: Sun, 2 Nov 2014 14:00:10 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: poma <pomidorabelisima@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] Ralink RT3070(rt2800usb) - The Tortoise and the
 Hare
Message-ID: <20141102130003.GA10104@redhat.com> (sfid-20141102_140307_073073_4402E08B)
References: <5455C833.2080706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5455C833.2080706@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 02, 2014 at 06:59:15AM +0100, poma wrote:
> Higher values, are they even possible via rt2800usb.ko & Co.?

Yes.

> ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 detected
> ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0005 detected

On the same RT and RF chipsets with TP-link WR-1043ND access point I have:

# iperf -c 192.168.1.105 -i 1
------------------------------------------------------------
Client connecting to 192.168.1.105, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.100 port 56993 connected with 192.168.1.105 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  4.75 MBytes  39.8 Mbits/sec
[  3]  1.0- 2.0 sec  8.12 MBytes  68.2 Mbits/sec
[  3]  2.0- 3.0 sec  8.00 MBytes  67.1 Mbits/sec
[  3]  3.0- 4.0 sec  8.75 MBytes  73.4 Mbits/sec
[  3]  4.0- 5.0 sec  7.00 MBytes  58.7 Mbits/sec
[  3]  5.0- 6.0 sec  9.00 MBytes  75.5 Mbits/sec
[  3]  6.0- 7.0 sec  8.25 MBytes  69.2 Mbits/sec
[  3]  7.0- 8.0 sec  7.75 MBytes  65.0 Mbits/sec
[  3]  8.0- 9.0 sec  8.75 MBytes  73.4 Mbits/sec
[  3]  9.0-10.0 sec  7.75 MBytes  65.0 Mbits/sec
[  3]  0.0-10.0 sec  78.2 MBytes  65.5 Mbits/sec

Stanislaw

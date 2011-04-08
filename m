Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm22-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.126]:23701 "HELO
	nm22-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751844Ab1DHJyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 05:54:16 -0400
Message-ID: <699128.18071.qm@web161601.mail.bf1.yahoo.com>
Date: Fri, 8 Apr 2011 02:54:15 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Questions about rt2800usb
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Steev Klimaszewski <steev@genesi-usa.com>,
	Jett Chen <jett_chen@ralinktech.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTi=kkBReSDHcCqyTkbHsAgDLiy7okg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Try:
> 
> iwconfig wlan0 power off
> 
> to disable powersaving.
> 
> Ivo

Hi Ivo,

Disabling power decreased latency substantially to a normal level, however it paved the way for myriad duplicate packets.

rt2800usb:

PING gmail.com (209.85.229.19) 56(84) bytes of data.
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=1 ttl=53 time=52.9 ms
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=2 ttl=53 time=50.2 ms
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=3 ttl=53 time=51.6 ms
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=4 ttl=53 time=52.8 ms
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=5 ttl=53 time=53.3 ms
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=6 ttl=53 time=51.4 ms
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=6 ttl=53 time=52.4 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=6 ttl=53 time=52.5 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=51.8 ms
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=54.8 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=56.5 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=58.2 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=59.9 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=61.3 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=62.9 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=7 ttl=53 time=63.3 ms (DUP!)
64 bytes from ww-in-f19.1e100.net (209.85.229.19): icmp_req=8 ttl=53 time=51.4 ms
^C
--- gmail.com ping statistics ---
8 packets transmitted, 8 received, +9 duplicates, 0% packet loss, time 7011ms
rtt min/avg/max/mdev = 50.285/55.181/63.304/4.219 ms

Without these, the rt2800usb is looking to be pretty stellar driver.

Walter

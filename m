Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39124 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751277Ab2AGWMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 17:12:40 -0500
Content-Type: text/plain; charset=UTF-8
From: John Wyzer <john.wyzer@gmx.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: HT40 not working for Intel 5100 AGN ?
In-reply-to: <1325965297-sup-3780@localhost>
References: <1325965297-sup-3780@localhost>
Date: Sat, 07 Jan 2012 23:12:21 +0100
Message-Id: <1325974267-sup-3125@localhost> (sfid-20120107_231259_704751_48976D15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was not a bug.
I had to search for ages however to find out about the fact that HT40 only
works with WPA2 and not with WPA. ;-)


Excerpts from John Wyzer's message of 2012-01-07 20:42:33 +0100:
> Kernel: git tag v3.2 
> 
> After modprobe:
> Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
> 
> If have an AP with openwrt configured to work with 802.11g+n, HT40+.
> A different Laptop with Windows installed connects with 150Mb/s
> 
> The maximum bitrate for the aforementioned Intel card however is displayed by
> iwconfig to be 54 Mb/s which seems to be confirmed by the actual transfer
> rates.
> The connection is being established by wpa_supplicant 0.7.3.
> 
> I tried researching this problem but did not really find it documented. Is this
> a known issue or can I provide further information for debugging? 
> 
> Many thanks,
> John
> 
> PS: please include me in the reply.

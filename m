Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:39465 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbYF1WGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 18:06:09 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1KCiYX-0007Lr-Vb
	for linux-wireless@vger.kernel.org; Sun, 29 Jun 2008 00:06:05 +0200
Message-ID: <4866B5BF.3000404@yahoo.com> (sfid-20080629_000619_112177_3D06CA31)
Date: Sat, 28 Jun 2008 23:05:51 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
MIME-Version: 1.0
To: Michael Buesch <public-mb-fseUSCV1ubazQB+pC5nmwQ@hugh.gmane.org>
CC: public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: WARNING: at net/mac80211/rx.c:319 __ieee80211_rx_handle_packet+0x325/0x775()
References: <4866A3A5.3060208@yahoo.com> <200806282357.30255.mb@bu3sch.de>
In-Reply-To: <200806282357.30255.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Michael Buesch wrote:
> On Saturday 28 June 2008 22:48:37 Sitsofe Wheeler wrote:
>> When I boot 2.6.26-rc8 on an x86_64 system I receive the following trace
>> in the logs:
>>
>>> [   72.384009] ------------[ cut here ]------------
>>> [   72.384021] WARNING: at net/mac80211/rx.c:319 __ieee80211_rx_handle_packet+0x325/0x775()
> 
> This seems to be the packet alignment warning. It's harmless
> on your machine. You can disable it by turning off CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT.
> 
> However, which wireless driver do you use? This is a bug in the driver.

The intel iwl3945 driver.


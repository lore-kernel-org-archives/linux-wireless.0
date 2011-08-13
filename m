Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39456 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab1HMUKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 16:10:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QsKX0-0004ll-7S
	for linux-wireless@vger.kernel.org; Sat, 13 Aug 2011 22:10:06 +0200
Received: from 95-89-156-251-dynip.superkabel.de ([95.89.156.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 22:10:06 +0200
Received: from bernd.schubert by 95-89-156-251-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 13 Aug 2011 22:10:06 +0200
To: linux-wireless@vger.kernel.org
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: carl9170 does not like all frequencies
Date: Sat, 13 Aug 2011 22:07:01 +0200
Message-ID: <4E46D965.5070103@fastmail.fm> (sfid-20110813_221014_506734_6758A673)
References: <j26l8a$ea9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org
In-Reply-To: <j26l8a$ea9$1@dough.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2011 10:02 PM, Bernd Schubert wrote:
> Hi all,
> 
> I bought a new usb wifi device with 2 antennas to get a better
> connection to my router. From point of few of connection strength that
> worked out very well, from point of view of connection stability that is
> total disaster so far. With Ubuntus 2.6.38-something it connects and
> then entirely fails after sending a few bytes. So I checked git log and
> noticed carl9170 is being used in recent kernels and connection issues
> have been fixed in 3.1-git. So I compiled this kernel and now I don't
> get a connection to my router at all anymore. And except of seeing my
> SSID and about 10 others from my neighbors, I now only can see two
> neighbor connections.
> 
> I guess that is due *lots* of messages like those:
> 
> 
>> [ 1058.936551] cfg80211: Calling CRDA to update world regulatory domain
>> [ 1058.945510] cfg80211: World regulatory domain updated:
>> [ 1058.945519] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>> [ 1058.945529] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [ 1058.945538] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> [ 1058.945547] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> [ 1058.945555] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [ 1058.945563] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> [ 1058.945604] cfg80211: Calling CRDA for country: 97
>> [ 1061.373997] ieee80211 phy1: channel change: 2417 -> 2422 failed (2).
>> [ 1061.682115] ieee80211 phy1: channel change: -1 -> 2422 failed (2).
>> [ 1061.682132] usb 10-1.2: restart device (7)
>> [ 1062.096523] cfg80211: Calling CRDA to update world regulatory domain
>> [ 1062.105469] cfg80211: World regulatory domain updated:

As a side note, I'm still getting those messages every 16 seconds. How I
can disable that spam?


Thanks,
Bernd



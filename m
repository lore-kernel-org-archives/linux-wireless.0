Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:46008 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073Ab1GRVOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 17:14:14 -0400
Date: Mon, 18 Jul 2011 17:14:07 -0400 (EDT)
From: Michael Forbes <miforbes@MIT.EDU>
To: Ben Hutchings <ben@decadent.org.uk>
cc: 633919@bugs.debian.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Bug#633919: /lib/modules/2.6.39-2-amd64/kernel/net/wireless/cfg80211.ko:
 cfg80211 calling CRDA drops wireless connection, clears ssid
In-Reply-To: <1310703973.8783.270.camel@localhost>
Message-ID: <alpine.DEB.2.02.1107181710350.26150@vincent> (sfid-20110718_231417_729675_2C143E04)
References: <20110715005011.15043.39294.reportbug@vincent> <1310703973.8783.270.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> 2011-07-14 20:38 [root@******** miforbes]# iw event
>> wlan0 (phy #0): deauth a0:88:b4:68:59:e4 -> 16:18:0a:30:23:5c reason 4: Disassociated due to inactivity
>> wlan0 (phy #0): disconnected (local request)
> [...]
>
> I would have expected that to appear in the kernel log.

Well, AFAIK `iw' doesn't seem to be well-integrated into Debian yet, and 
indeed wasn't installed on my laptop until I did so manually.  `iwevent' 
doesn't give the reason for deauthentication.  So perhaps the log just 
isn't getting the information from the right sources.

> Don't know what's going on here but maybe the upstream wireless
> developers can work it out.

Thanks!

-Michael

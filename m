Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61984 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXDUWzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 18:55:35 -0400
Message-ID: <462A965D.9000708@lwfinger.net>
Date: Sat, 21 Apr 2007 17:55:25 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Pavel Roskin <proski@gnu.org>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ieee80211: Output frequency rather than channel in scan  results
References: <46298e00.m7oDqYNvDCFdCSj1%Larry.Finger@lwfinger.net>	 <20070421001253.q449myskosg0sg8k@webmail.spamcop.net> <1177193997.19554.1.camel@localhost.localdomain>
In-Reply-To: <1177193997.19554.1.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Sat, 2007-04-21 at 00:12 -0400, Pavel Roskin wrote:
>> Quoting Larry Finger <Larry.Finger@lwfinger.net>:
>>
>>> In ieee80211, the output of scan results lists channels rather than
>>> frequencies; however, NetworkManager needs frequency. This patch
>>> changes the output from channel to frequency.
>> The driver can report both, and I think it should.  This would make the iwlist
>> output a bit longer, but kernel drivers shouldn't be written to make userspace
>> program generate pretty output.
> 
> I'm trying to remember why NM cares about frequency, and I think it's
> for ad-hoc mode; but wpa_supplicant didn't historically support a
> "channel" configuration parameter and so you can't create adhoc networks
> with NM right now anyway...  What's the failure mode?

In the KDE NM applet, the frequency is listed as 0.

Larry

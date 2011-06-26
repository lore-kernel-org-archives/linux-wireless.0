Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55803 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab1FZOpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 10:45:32 -0400
Message-ID: <4E074609.5080500@openwrt.org> (sfid-20110626_165041_497979_A9307605)
Date: Sun, 26 Jun 2011 16:45:29 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Joerg Pommnitz <pommnitz@yahoo.com>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] Performance regression between Madwifi/net80211
 and ath5k/mac80211
References: <loom.20110621T215346-191@post.gmane.org>	<BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>	<1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>	(sfid-20110622_154146_913504_76736765)	<1308750416.29571.10.camel@jlt3.sipsolutions.net>	<1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>	<1308754204.29571.15.camel@jlt3.sipsolutions.net> <1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
In-Reply-To: <1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-22 5:07 PM, Joerg Pommnitz wrote:
>>  I guess you'll  need more help from the HW people here.
>
> Bob, Bruno, Felix, Luis, Nick: Do you read?
What mac80211/ath5k version did you use? If you're using the in-kernel 
ath5k from 2.6.38, then I'd suggest testing with a recent 
compat-wireless version. I made some bug fixes and performance 
improvements in April - and I think those went into 2.6.39.

- Felix

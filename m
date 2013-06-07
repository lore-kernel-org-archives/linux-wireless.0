Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47810 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab3FGNtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 09:49:47 -0400
Message-ID: <51B1E4F3.9020509@openwrt.org> (sfid-20130607_154950_099808_9AB8D0C4)
Date: Fri, 07 Jun 2013 15:49:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jakub Kicinski <moorray3@wp.pl>
CC: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: Re: [RFC 4/5] mac80211: enforce address verification on monitors
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl> <1370612179-24385-5-git-send-email-moorray3@wp.pl>
In-Reply-To: <1370612179-24385-5-git-send-email-moorray3@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-07 3:36 PM, Jakub Kicinski wrote:
> From: Jakub Kicinski <kubakici@wp.pl>
> 
> Mac address of passive monitor have to treated
> the same as address any other interface because
> type of interface can be changed or monitor can
> be later put into active mode.
It can't. There's checks preventing that. I'd prefer to leave that part
of the code as it is, the MAC address for normal monitor interfaces
should be ignored completely.

- Felix

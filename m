Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34666 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3EaUwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 16:52:12 -0400
Received: by mail-ob0-f178.google.com with SMTP id fb19so3832072obc.23
        for <linux-wireless@vger.kernel.org>; Fri, 31 May 2013 13:52:11 -0700 (PDT)
Date: Fri, 31 May 2013 16:51:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: Another try at getting pktgen to work with wifi.
Message-ID: <20130531205117.GA27551@localhost> (sfid-20130531_225216_006753_CFFCBFBF)
References: <51A79E4A.7000609@candelatech.com>
 <51A7B049.9090201@openwrt.org>
 <51A7BA63.4080403@candelatech.com>
 <51A857BF.7070008@openwrt.org>
 <51A8DC1C.1040908@candelatech.com>
 <1370021846.14117.13.camel@jlt4.sipsolutions.net>
 <51A8E53E.8030101@candelatech.com>
 <1370025698.14117.15.camel@jlt4.sipsolutions.net>
 <51A8F141.5050804@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51A8F141.5050804@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 31, 2013 at 11:51:45AM -0700, Ben Greear wrote:
> cfg80211_classify8021d uses it to determine the queue in if skb->priority is
> set to a special range (hard coded un-documented hack from hell, it appears).
> 
> I didn't go looking to find out where those magic values might be set.

Actually, this hard coded hack from hell is documented :)

http://wireless.kernel.org/en/developers/Documentation/mac80211/queues?highlight=%28so_priority%29

-- 
Bob Copeland %% www.bobcopeland.com

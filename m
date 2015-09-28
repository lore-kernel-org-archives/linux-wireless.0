Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bluebottle.com ([176.9.67.91]:46800 "EHLO
	mail.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbbI1MzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 08:55:08 -0400
Date: Mon, 28 Sep 2015 14:52:38 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bastian Bittorf <bittorf@bluebottle.com>,
	Pavel Machek <pavel@ucw.cz>, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: Low latency communication over wifi
Message-ID: <20150928125238.GJ22537@medion.lan> (sfid-20150928_145513_470862_575B9397)
References: <20150926102403.GA21555@amd>
 <1443426103.2401.1.camel@sipsolutions.net>
 <20150928121504.GE22537@medion.lan>
 <1443443851.2401.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443443851.2401.6.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg <johannes@sipsolutions.net> [28.09.2015 14:38]:
> Depends what you're measuring, but ping should apply the same DSCP tag
> on the response I believe.

your are right, I did not know this till yet 8-)
(i applied 0xb8 with 'ping -c1 -Q' just for testing)

14:49:52.491925 IP (tos 0xb8, ttl 64, id 51117, offset 0, flags [+], proto ICMP (1), 
	length 1500) 192.168.2.1 > 192.168.2.103: ICMP echo reply, id 14925, seq 1, length 1480
14:49:52.491993 IP (tos 0xb8, ttl 64, id 51117, offset 1480, flags [none], proto ICMP (1),
	length 48) 192.168.2.1 > 192.168.2.103: icmp

bye, bastian

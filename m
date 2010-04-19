Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45961 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab0DSSAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 14:00:11 -0400
Message-ID: <4BCC9A27.9000104@openwrt.org>
Date: Mon, 19 Apr 2010 20:00:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: rc80211_minstrel.c:70 WARNING with 2.6.34-rc4
References: <20100418085653.GA7345@linux-m68k.org> <1271694855.9026.51.camel@mj> <20100419174100.GA5312@linux-m68k.org> <4BCC95CC.7030109@openwrt.org> <20100419175508.GB5312@linux-m68k.org>
In-Reply-To: <20100419175508.GB5312@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-19 7:55 PM, Richard Zidlicky wrote:
> On Mon, Apr 19, 2010 at 07:41:32PM +0200, Felix Fietkau wrote:
> 
> 
>> This warning typically shows up, whenever the driver reports a rate to
>> minstrel in the tx status that is not part of the supported/negotiated
>> rate set - that's the reason the index lookup above fails.
> 
> can that happen when both ends are configured to a fixed rate of 11M?
No idea. I've never used fixed-rate. I guess it could, if it uses 11M
for communicating with a peer that it for some reason did not enable
this rate for.

 - Felix

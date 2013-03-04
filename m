Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:40433 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493Ab3CDQLX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 11:11:23 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2 0/7] mac80211: improve and consolidate minstrel rate control 
From: =?iso-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1362410065.21028.19.camel@jlt4.sipsolutions.net>
Date: Mon, 4 Mar 2013 17:11:23 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Message-Id: <8739FF55-8F45-4C2C-A756-5F5E2FE77C58@net.t-labs.tu-berlin.de> (sfid-20130304_171131_864270_E95BB923)
References: <1362406937-69969-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <1362410065.21028.19.camel@jlt4.sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 04.03.2013, at 16:14, Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2013-03-04 at 15:22 +0100, Thomas Huehn wrote:
>> This patch series merges functions, macros and sampling improvements from
>> minstrel_ht into minstrel. It adds several improvements to the rate control.  
> 
> While this compiles, sparse is very unhappy:
> 
> net/mac80211/rc80211_minstrel.c:386:18: error: bad constant expression
> net/mac80211/rc80211_minstrel.c:394:47: error: cannot size expression

I will fix this wrong array initialization in v3. Thx for finding this.

> 
> I'd definitely prefer sparse to not error on this code (I can live with
> warnings) so it remains useful.
> 
> johannes

Greetings Thomas.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37280 "EHLO
	mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161156AbcFAMzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 08:55:13 -0400
Received: by mail-it0-f48.google.com with SMTP id z123so18585099itg.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2016 05:55:12 -0700 (PDT)
Date: Wed, 1 Jun 2016 08:54:53 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Subject: Re: wireless-testing on 4.7
Message-ID: <20160601125453.GB12977@localhost> (sfid-20160601_145521_854648_3562563C)
References: <20160529214059.GA15677@localhost>
 <CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Luca, Emmanuel

On Tue, May 31, 2016 at 10:06:57PM -0600, Reinoud Koornstra wrote:
> Today I compiled 4.6+ and pulled sources today
> iwlwifi isn't super smooth.

I assume you mean wireless-testing, based on 4.7-rc1 (as this email is
in reply to my announcement of same).

> 
> [  112.345457] wlp4s0: authenticate with 00:30:44:1d:cf:2b
> [  112.349002] wlp4s0: send auth to 00:30:44:1d:cf:2b (try 1/3)
> [  112.349647] wlp4s0: authenticated
> [  112.352456] wlp4s0: associate with 00:30:44:1d:cf:2b (try 1/3)
> [  112.353764] wlp4s0: RX AssocResp from 00:30:44:1d:cf:2b (capab=0x11
> status=0 aid=3)
> [  112.355035] wlp4s0: associated
> [  112.355393] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
> [  118.616327] wlp4s0: deauthenticated from 00:30:44:1d:cf:2b (Reason:
> 15=4WAY_HANDSHAKE_TIMEOUT)
> [  128.673812] wlp4s0: authenticate with 00:30:44:1d:cf:2b
> [  128.676997] wlp4s0: send auth to 00:30:44:1d:cf:2b (try 1/3)
> [  128.677648] wlp4s0: authenticated
> [  128.678691] wlp4s0: associate with 00:30:44:1d:cf:2b (try 1/3)
> [  128.679807] wlp4s0: RX AssocResp from 00:30:44:1d:cf:2b (capab=0x11
> status=0 aid=3)
> [  128.681198] wlp4s0: associated
> 
> I never experienced the 4 way handshake 802.11i timeout in my home setup.
> With other setups plenty of times, especially with mediatek drivers. :)
> If you wish I can sniff and see which side is at fault.

I have not noticed any problems on my laptop with iwldvm on a 6205, with
latest wireless-testing.  But maybe intel devs can weigh in.

-- 
Bob Copeland %% http://bobcopeland.com/

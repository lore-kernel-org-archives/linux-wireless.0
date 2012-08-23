Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36521 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab2HWVUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 17:20:38 -0400
Message-ID: <50369EA4.7030609@candelatech.com> (sfid-20120823_232042_486700_242B7538)
Date: Thu, 23 Aug 2012 14:20:36 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Paul Stewart <pstew@google.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Any suggestions for programmable attenuators?
References: <50117096.8010706@candelatech.com> <CAMcMvsjVciPhx_aiYzBg+K5oLVGv=f_2TSZ125TJN_ngk__d9g@mail.gmail.com>
In-Reply-To: <CAMcMvsjVciPhx_aiYzBg+K5oLVGv=f_2TSZ125TJN_ngk__d9g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2012 10:29 AM, Paul Stewart wrote:
> We have a few units from eubus (http://www.eubus.net, ATS0760-95).
> They're fairly easy to interface to (we're controlling them with a
> BeagleBone, but need level shifting because they are 5V devices).  We
> don't have a whole lot of seat time with them so far, but we've
> validated that they work.

I've managed to wire up some of these as well (using Arduino as controller).

One thing I notice is that the smallest signal quality I can see
reported by the NIC (ath9k) is about -81 or -82 dBm.

Technically, the attenuator should be able to go below the
noise floor of around -90dbm if I understand things properly.

Have you done any testing of this nature?

And for what it's worth, using ath9k, 1x1 MIMO (one channel) /n, ht40 on 5ghz,
I get almost 8Mbps UDP download at -80 dBm signal quality :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32855 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab2E1Dz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 23:55:59 -0400
Message-ID: <4FC2F73F.4070701@candelatech.com> (sfid-20120528_055611_102330_E2A2A390)
Date: Sun, 27 May 2012 20:55:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <4FC0F8CE.1030303@candelatech.com> <20417.972.888113.821079@gargle.gargle.HOWL> <20417.1857.115550.807746@gargle.gargle.HOWL> <4FC2437C.9090106@candelatech.com> <CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
In-Reply-To: <CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2012 10:40 AM, Adrian Chadd wrote:
> On 27 May 2012 08:08, Ben Greear<greearb@candelatech.com>  wrote:
>
>> Do you have a link to anyone selling this AP, or is it just an
>> engineering sample as well?
>
> The board is an engineering sample but (a) customers and developers
> can ask for them under NDA, (b) yes, openwrt developers have done this
> and have the hardware, and (c) the chip is shipping as far as I'm
> aware.
>
> It's "just" a MIPS74k + AR9340 (3x3) + on-board AR9580 I think. I'll
> have to double check. The wireless NIC side of things is pretty
> standard though, so any Osprey NIC will be fine.

Ok, I think I understand.  But, "Osprey" returns no useful results
that I can find, so it must be some internal code name for a project.

If you can be more specific about exactly what chipsets/NICs
this includes it would be useful for those of us without NDAs or
other internal Atheros/Qualcomm connections.

As far as shipping chipsets go (perhaps from the list below)
http://www.qca.qualcomm.com/technology/technology.php?nav1=47

What is considered the top-end Atheros chip for fastest/best 3x3 MIMO speeds?

Maybe 9390 (EW-DNXA-H1 for instance?) is expected to be better than 9380?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

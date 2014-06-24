Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42006 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaFXCfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 22:35:40 -0400
Message-ID: <53A8E3F9.7000001@candelatech.com> (sfid-20140624_043543_826514_6B4ED4C1)
Date: Mon, 23 Jun 2014 19:35:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	wireless-regdb@lists.infradead.org
Subject: Re: [RFC] wireless:  improve dfs-region intersection.
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com> <20140623191504.GD1390@garbanzo.do-not-panic.com> <53A89011.1010806@candelatech.com> <20140623205451.GG1390@garbanzo.do-not-panic.com> <53A89A0F.9090509@candelatech.com> <20140624004442.GH1390@garbanzo.do-not-panic.com>
In-Reply-To: <20140624004442.GH1390@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Maybe just use time-zone or user hints in this case since NICs cannot
>> be fully trusted.
>
> WTF no, the regulatory hint stuff should all be automated and user input
> should really only come from trusted sources, see the cell base station
> hint as a good example use case. The NICs are trusted as that's what
> regulatory bodies like folks to do. Hell even the country IEs are only
> trusted for the alpha2, the actual contents are disregarded. Regular
> user input should only help compliance further, that's it.

NICs just aren't that reliable, seems you can buy NICs with any number
of regulatory domains on the interweb, and then you can hop on a plane
and go other interesting places.

If you ever have a system with NICs with two different regulatory domains,
I assume it is very likely that it was not certified in that configuration.
Maybe the user's input (and AP's beacons and such) are more reliable in this
case.

But, not worth arguing about at this point.  As long as the basic regulatory
bugs are fixed (as per the other thread), then my problems should be solveable.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

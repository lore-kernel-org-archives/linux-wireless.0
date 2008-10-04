Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:58387 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbYJDPQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 11:16:30 -0400
Message-ID: <48E788BC.7030806@lwfinger.net> (sfid-20081004_171641_615662_0238186A)
Date: Sat, 04 Oct 2008 08:16:12 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: Trendnet TEW-424UB now Realtek 8187B
References: <20081004011510.GA10015@gate.kl-ic.com>	 <1223109126.24551.70.camel@johannes.berg>	 <43e72e890810040147j6f15966awbe555b6d37135960@mail.gmail.com>	 (sfid-20081004_104814_044310_A217A3F8) <1223110250.24551.72.camel@johannes.berg>
In-Reply-To: <1223110250.24551.72.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2008-10-04 at 01:47 -0700, Luis R. Rodriguez wrote:
>> What Realtek driver? Just FYI rtl8187 does *not* claim the RTL8187B. See:
>>
>> http://wireless.kernel.org/en/users/Drivers/rtl8187
> 
> Oh, I thought there was a version now that did.

There is. Both Linus's tree and wireless-testing support the 8187B. In
fact, I'm using one right now.

As for the contention that it is buggy - I don't find it any worse
than b43, and quite a bit better than p54usb, the two other wireless
drivers that I use. Reports of failures that are posted in the Redhat
Bugzilla cannot be duplicated by me.

Larry


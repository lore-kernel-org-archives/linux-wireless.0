Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50026 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161541AbXDLDl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 23:41:27 -0400
Message-ID: <461DAABE.1060607@lwfinger.net>
Date: Wed, 11 Apr 2007 22:42:54 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: Hide if bcm43xx-mac80211 is builtin
References: <200704111901.06403.flamingice@sourmilk.net> <1176336070.1298.17.camel@localhost.localdomain>
In-Reply-To: <1176336070.1298.17.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Wed, 2007-04-11 at 19:01 -0400, Michael Wu wrote:
>> bcm43xx: Hide if bcm43xx-mac80211 is builtin
>>
>> From: Michael Wu <flamingice@sourmilk.net>
>>
>> This prevents users from compiling bcm43xx (softmac) and bcm43xx-mac80211
>> into the kernel at the same time. In the case that it is attempted, make
>> bcm43xx (softmac) not build.
> 
> What kernel version is this targetted at?  Have the mac80211 bits
> reached feature parity with the softmac bits?  I'm still hearing quite a
> few reports of mac80211 being flaky WRT WEXT implementation and
> compatibility.  I don't necessarily object, I just want to make sure
> that when this patch hits released kernels, that the mac80211 port is in
> the same or better shape than the softmac one.

This is aimed at Linville's wireless-dev and the -mm tree where both softmac and mac80211 versions 
coexist.

At the moment, mac80211 is not in as good shape as softmac, and a date for its addition to mainline 
has not been set.

Larry


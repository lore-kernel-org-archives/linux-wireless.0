Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65397 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759193Ab3AQIpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 03:45:16 -0500
Received: by mail-wi0-f171.google.com with SMTP id hn14so4271229wib.4
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 00:45:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358378606.15012.63.camel@jlt4.sipsolutions.net>
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
 <1358248982.4648.1.camel@jlt4.sipsolutions.net> <CABPxzYJciFXV=S7BGWT_V-M8U9ydpiBT8RSJJn35oHQy+zh3aQ@mail.gmail.com>
 <CAJ-Vmon_m1bH_OTL7XitXwRvqPK2+Q-V7E=rcBdGw7Gkj58LJQ@mail.gmail.com> <1358378606.15012.63.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 17 Jan 2013 14:14:53 +0530
Message-ID: <CABPxzY+2qNLxoySMou+PzqzfhK4ZOVfcP08BwZGx0J2Bz3Sd1Q@mail.gmail.com> (sfid-20130117_094521_962238_3D9ABE73)
Subject: Re: Tx AMSDU Support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Adrian Chadd <adrian@freebsd.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok...will try with the below ones..Marvell definitely has support for AMSDU Tx.

On Thu, Jan 17, 2013 at 4:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-01-16 at 15:05 -0800, Adrian Chadd wrote:
>> .. for testing that out, I ended up just using a NIC that implements
>> AMSDU in software.
>>
>> God knows what it was though (intel?)..
>
> Probably Broadcom and/or Marvell.
>
> johannes
>

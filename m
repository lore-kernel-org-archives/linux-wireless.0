Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33585 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2DPGDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:03:40 -0400
Message-ID: <4F8BB636.7020509@qca.qualcomm.com> (sfid-20120416_080344_054613_DED61046)
Date: Mon, 16 Apr 2012 09:03:34 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: <dwmw2@infradead.org>, <ath6kl-devel@qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] linux-firmware: ath6k update 20120410
References: <20120410121708.15361.62740.stgit@x201> <1334541087.3209.39.camel@deadeye>
In-Reply-To: <1334541087.3209.39.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 04:51 AM, Ben Hutchings wrote:
> On Tue, 2012-04-10 at 15:18 +0300, Kalle Valo wrote:
>> (Resending as my --cc had a space and stgit didn't send this to the
>> mailing lists.)
>> 
>> Hi Ben,
>> 
>> here's a firmware update for ath6k. We update the AR6003 hw2.1.1 to
>> the latest in our 3.2.0 branch and add a new firmware for AR6004.
>> 
>> This is the first time I'm sending patches for linux-firmware so
>> please let me know if there are any errors.
> 
> I've applied these.

Thanks.

> However, in future please only add File: lines to WHENCE for regular
> files.  I've now removed all such lines from the listings for
> ath6kl.

I will do that in my next submission. Thanks for fixing the entries for us.

Kalle

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f173.google.com ([209.85.160.173]:62344 "EHLO
	mail-gh0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3BRREE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 12:04:04 -0500
Message-ID: <51225F00.9020707@lwfinger.net> (sfid-20130218_180414_430744_9A677D04)
Date: Mon, 18 Feb 2013 11:04:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bastian Bittorf <bittorf@bluebottle.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] b43: Increase number of RX DMA slots
References: <1361156480-32566-1-git-send-email-Larry.Finger@lwfinger.net> <CACna6rwLgE+o2mcRTemLFAqzdsEoA9Xyx8GyEQTh5qbv1iZ04A@mail.gmail.com> <20130218165510.GC8730@medion.lan>
In-Reply-To: <20130218165510.GC8730@medion.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 10:55 AM, Bastian Bittorf wrote:
> * Rafał Miłecki <zajec5@gmail.com> [18.02.2013 17:54]:
>> 2013/2/18 Larry Finger <Larry.Finger@lwfinger.net>:
>>
>> So probably ideal solution is to use 128 *and* fix the driver's
>> failing on overflow ;)
>
> i will run a test tomorrow an report, keep calm.

Do you have debugging turned on for b43? If so, the slot usage line at module 
unload would be useful.

Larry



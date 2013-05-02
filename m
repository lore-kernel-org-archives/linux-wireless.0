Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:36668 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340Ab3EBPBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 11:01:53 -0400
Received: by mail-ob0-f177.google.com with SMTP id un3so554444obb.36
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 08:01:53 -0700 (PDT)
Message-ID: <51827FDF.3060406@lwfinger.net> (sfid-20130502_170157_385010_8FF5350B)
Date: Thu, 02 May 2013 10:01:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: Thommy Jakobsson <thommyj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net> <20130502150603.2ac36385@milhouse>
In-Reply-To: <20130502150603.2ac36385@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2013 08:06 AM, Michael Büsch wrote:
> On Tue, 23 Apr 2013 21:45:11 +0200 (CEST)
> Thommy Jakobsson <thommyj@gmail.com> wrote:
>
>> From: Thommy Jakobsson <thommyj@gmail.com>
>>
>> Add handling of rx descriptor underflow. This fixes a fault that could
>> happen on slow machines, where data is received faster than the CPU can
>> handle. In such a case the device will use up all rx descriptors and
>> refuse to send any more data before confirming that it is ok. This
>> patch enables necessary interrupt to discover such a situation and will
>> handle them by dropping everything in the ring buffer.
>>
>> Reviewed-by: Michael Buesch <m@bues.ch>
>> Signed-off-by: Thommy Jakobsson <thommyj@gmail.com>
>> Cc: stable <stable@vger.kernel.org>
>
> Anybody interested in porting this to b43legacy (and testing)?

Michael,

I will take care of that. It may take a while due to other projects.

Larry



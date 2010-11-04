Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45487 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0KDATd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 20:19:33 -0400
Received: by wwb13 with SMTP id 13so52769wwb.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 17:19:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101102082254.GL1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <20101102082254.GL1733@mail.wantstofly.org>
From: Brian Cavagnolo <brian@cozybit.com>
Date: Wed, 3 Nov 2010 17:19:11 -0700
Message-ID: <AANLkTi=iQgc+cMTrwGWyriHvOCGhAZ7TU+41ytBRYtea@mail.gmail.com>
Subject: Re: [PATCH 1/7] mwl8k: add firmware files for 8366
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 2, 2010 at 1:22 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Mon, Nov 01, 2010 at 05:55:45PM -0700, Brian Cavagnolo wrote:
>
>> From: Nishant Sarmukadam <nishants@marvell.com>
>>
>> Add Helper image, client image (4.1.0.3) and ap image (5.2.6.6)
>>
>> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
>> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
>
> NAK, for obvious reasons.
>
> Also, spamming thousands of people's inboxes with 500kb firmware
> patches is generally not a nice thing to do.
>

Well, patches containing hundreds of kB of binary firmware do pass
through this mailing list.  However, a closer inspection reveals that
these were destined for the linux-firmware with linux-wireless CC'd.
My bad.  When I resubmit I'll do it that way.

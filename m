Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56598 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1HYR3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 13:29:53 -0400
Received: by vxi9 with SMTP id 9so1878262vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 10:29:53 -0700 (PDT)
Message-ID: <4E56868E.7010404@lwfinger.net> (sfid-20110825_192956_840703_81788327)
Date: Thu, 25 Aug 2011 12:29:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] b43: Relax requirement for descriptors to be in the
 DMA zone
References: <4e55750c.GPPIrbNLynUMWY/U%Larry.Finger@lwfinger.net> <CACna6ryVB3yTj7rQbSdCqrw-9WtaPZedM7Ug6JV0iTDQQOv=Sw@mail.gmail.com>
In-Reply-To: <CACna6ryVB3yTj7rQbSdCqrw-9WtaPZedM7Ug6JV0iTDQQOv=Sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2011 12:24 PM, Rafał Miłecki wrote:
> 2011/8/25 Larry Finger<Larry.Finger@lwfinger.net>:
>> When 64-bit DMA was first used, there were problems with the
>> BCM4311 (14e4:4311). The problem was "fixed" by using the GFP_DMA
>> flag in the allocation of coherent ring descriptor memory.
>>
>> The original problem is now believed to have been due to bugs in
>> the 64-bit DMA implementation in the rest of the kernel, and that
>> those bugs have been fixed. Accordingly, the requirement for the
>> descriptors to be in the DMA zone is relaxed.
>
> Larry, it is not clear to me from the commit message: did you test
> that patch with your 14e4:4311?

Yes.

Larry

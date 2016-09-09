Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50256 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754094AbcIIL1q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 07:27:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: mwifiex: PCIe8997 chip specific handling
References: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
        <20160909091449.A66606183E@smtp.codeaurora.org>
        <5c381ec576c54a7fad54e7a23a060e29@SC-EXCH04.marvell.com>
Date: Fri, 09 Sep 2016 14:27:39 +0300
In-Reply-To: <5c381ec576c54a7fad54e7a23a060e29@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Fri, 9 Sep 2016 10:28:18 +0000")
Message-ID: <87a8fhqpn8.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_132750_506996_E363935C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> Hi Kalle,
>
>> -----Original Message-----
>> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] On Behalf Of Kalle Valo
>> Sent: Friday, September 09, 2016 2:45 PM
>> To: Amitkumar Karwar
>> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
>> Amitkumar Karwar
>> Subject: Re: mwifiex: PCIe8997 chip specific handling
>> 
>> Amitkumar Karwar <akarwar@marvell.com> wrote:
>> > The patch corrects the revision id register and uses it along with
>> > magic value and chip version registers to download appropriate
>> > firmware image.
>> >
>> > PCIe8997 Z chipset variant code has been removed, as it won't be used
>> > in production.
>> >
>> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> 
>> Does apply, please rebase:
>> 
>> Applying: mwifiex: PCIe8997 chip specific handling
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/marvell/mwifiex/pcie.c).
>> Repository lacks necessary blobs to fall back on 3-way merge.
>> Cannot fall back to three-way merge.
>> Patch failed at 0001 mwifiex: PCIe8997 chip specific handling
>> 
>
> The patch now smoothly applies to top of the tree. It had a dependency
> with "mwifiex: add PCIe function level reset support" which is merged.
> Let me know if there is still a problem.

Ok, I applied it now. But if there's a dependency to another patch
please document it after the "---" line, a lot easier that way.

-- 
Kalle Valo

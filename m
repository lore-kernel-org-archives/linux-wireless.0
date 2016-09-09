Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55158 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753600AbcIIJUA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 05:20:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex: add PCIe function level reset support
References: <1469541704-2880-1-git-send-email-akarwar@marvell.com>
        <20160903154016.4BCE56217C@smtp.codeaurora.org>
        <86c718ca301b4da2ba814c049b78e6b3@SC-EXCH04.marvell.com>
Date: Fri, 09 Sep 2016 12:19:54 +0300
In-Reply-To: <86c718ca301b4da2ba814c049b78e6b3@SC-EXCH04.marvell.com>
        (Amitkumar Karwar's message of "Thu, 8 Sep 2016 15:05:46 +0000")
Message-ID: <87eg4tqvk5.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_112019_020531_DA7819CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

>> Doesn't apply anymore, please rebase.
>> 
>> Applying: mwifiex: add PCIe function level reset support
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/marvell/mwifiex/main.c).
>> Repository lacks necessary blobs to fall back on 3-way merge.
>> Cannot fall back to three-way merge.
>> Patch failed at 0001 mwifiex: add PCIe function level reset support
>
> It gets applied smoothly if below patches are applied first.
> https://patchwork.kernel.org/patch/9310499/ ([v5,1/2] mwifiex: add manufacturing mode support)
> https://patchwork.kernel.org/patch/9310501/ ([v5,2/2] mwifiex: add cfg80211 testmode support)
>
> Please let me know if you want me to rebase "PCIe function level reset
> support". In that case I need to rebase and send above 2 patches as
> well.

Yes, I was able to apply this after those patches. No need to resend.

-- 
Kalle Valo

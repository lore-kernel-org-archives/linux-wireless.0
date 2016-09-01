Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59611 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbcIAO26 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 10:28:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2016-08-30-2
References: <1472556999.27868.86.camel@coelho.fi>
Date: Thu, 01 Sep 2016 17:28:53 +0300
In-Reply-To: <1472556999.27868.86.camel@coelho.fi> (Luca Coelho's message of
        "Tue, 30 Aug 2016 14:36:39 +0300")
Message-ID: <87twdz1yoq.fsf@kamboji.qca.qualcomm.com> (sfid-20160901_162901_669756_458DB8F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> This is a v2 of my pull request with the potential below array bounds
> access, reported by kbuild bot, fixed.
>
>> Another pull request, this time intended for 4.9.  I have a lot of
>> patches to send, but I'll send smaller batches this time. :)
>> 
>> These patches contain mostly preparation for new HW, but also some
>> improvements in the dynamic queue allocation code and the
>> implementation to support GMAC.
>
> Let me know if everything's fine (or not). :)
>
> Luca.
>
>
> The following changes since commit 60747ef4d173c2747bf7f0377fb22846cb422195:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2016-08-18 01:17:32 -0400)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2016-08-30-2

Pulled, thanks.

-- 
Kalle Valo

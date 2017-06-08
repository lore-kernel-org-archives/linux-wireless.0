Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43732 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdFHMHG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 08:07:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: linux-next: build failure after merge of the wireless-drivers-next tree
References: <20170608122759.7ffda0c3@canb.auug.org.au>
        <3594bd0d-e2b4-a380-ba06-8dedbbcbe11f@quantenna.com>
        <20170608125737.1e09c36d@canb.auug.org.au>
Date: Thu, 08 Jun 2017 15:07:00 +0300
In-Reply-To: <20170608125737.1e09c36d@canb.auug.org.au> (Stephen Rothwell's
        message of "Thu, 8 Jun 2017 12:57:37 +1000")
Message-ID: <87lgp24ra3.fsf@codeaurora.org> (sfid-20170608_140800_848204_D96688C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Igor,
>
> On Wed, 7 Jun 2017 19:43:18 -0700 Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:
>>
>> thanks. As I understand, you've applied this patch during a merge and no 
>> further actions are required, correct?
>
> Dave Miller will need to apply that patch (or something similar) when
> he merges the wireless-drivers-next tree into the net-next tree.  I
> will keep applying the patch each day until then.

Thanks, I'll remind Dave about this when i submit the pull request (very
soon now).

-- 
Kalle Valo

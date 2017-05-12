Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756678AbdELP1O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 11:27:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: Rob Herring <robh@kernel.org>, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/3] Documentation: dt: net: add mt76 wireless device binding
References: <20170207202035.64224-1-nbd@nbd.name>
        <20170207202035.64224-2-nbd@nbd.name>
        <20170215223324.r7cgljfqkulyuany@rob-hp-laptop>
Date: Fri, 12 May 2017 18:27:08 +0300
In-Reply-To: <20170215223324.r7cgljfqkulyuany@rob-hp-laptop> (Rob Herring's
        message of "Wed, 15 Feb 2017 16:33:24 -0600")
Message-ID: <87fuga6qpf.fsf@purkki.adurom.net> (sfid-20170512_172717_386193_75DA343C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Herring <robh@kernel.org> writes:

> On Tue, Feb 07, 2017 at 09:20:33PM +0100, Felix Fietkau wrote:
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>
> Commit msg? Also, use "dt-bindings: net: " for the subject prefix.

Felix, are you planning to submit v6? Now that we are close to -rc1
release it's the best time to get this driver merged.

Also in patch 3 it would be good to have longer commit log, for example
describing what works (and what not), what modes are supported etc.

I applied this to pending branch for kbuild bot testing:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/log/?h=pending

-- 
Kalle Valo

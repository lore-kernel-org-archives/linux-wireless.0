Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 8bytes.org ([81.169.241.247]:43546 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbcIIIie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 04:38:34 -0400
Date: Fri, 9 Sep 2016 10:38:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Valerio Passini <valerio.passini@unicam.it>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Adam Morrison <mad@cs.technion.ac.il>,
        linux-wireless@vger.kernel.org,
        Omer Peleg <omer@cs.technion.ac.il>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: Stability connection problems in ath9k kernel 4.7
Message-ID: <20160909083832.GX1437@8bytes.org> (sfid-20160909_103857_717175_C668EF82)
References: <1798564.U2X6r5Zons@automatix>
 <87wpio155z.fsf@purkki.adurom.net>
 <2596121.7secQ7hYiJ@automatix>
 <87d1kes3qe.fsf@kamboji.qca.qualcomm.com>
 <CAC6K2=_Hdkgc_6igoC59J_Cn9=bdye827zbEK7PWtZY6ebh-6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC6K2=_Hdkgc_6igoC59J_Cn9=bdye827zbEK7PWtZY6ebh-6Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Valerio,

On Thu, Sep 08, 2016 at 09:07:56PM +0200, Valerio Passini wrote:
> I'm hoping having done it right and I can try your first suggestion, but I
> really cannot solve this problem by myself: sorry, I have no capabilities in
> programming in any known and unknown computer language. Surely, I can test all
> the patches you want and report the results but this is the best I can do. Best
> regards

Can you please send me the full dmesg after boot? The Intel-IOMMU is not
enabled by default, so I want to check if it is either enabled by
kernel-config or kernel command-line.

Thanks,

	Joerg

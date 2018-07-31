Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0076.outbound.protection.outlook.com ([104.47.34.76]:29024
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731500AbeGaLjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 07:39:23 -0400
Date: Tue, 31 Jul 2018 12:59:31 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 6/6] qtnfmac: implement basic WoWLAN support
Message-ID: <20180731095929.nskgxmi3siyrjvvv@bars> (sfid-20180731_115953_394736_D1239631)
References: <20180531091102.28666-7-sergey.matyukevich.os@quantenna.com>
 <20180730141342.B613A61D77@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180730141342.B613A61D77@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello Kalle,

> > This patch implements core WoWLAN support in qtnfmac driver, including
> > processing of WoWLAN features reported by firmware and implementation
> > of cfg80211 suspend/resume/wakeup callbacks. Currently the following
> > WoWLAN triggers are supported: disconnect, magic packet,
> > custom pattern packet.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> Doesn't apply anymore as I dropped patch 5
> 
> fatal: sha1 information is lacking or useless (drivers/net/wireless/quantenna/qtnfmac/cfg80211.c).
> error: could not build fake ancestor
> Applying: qtnfmac: implement basic WoWLAN support
> Patch failed at 0001 qtnfmac: implement basic WoWLAN support
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> 
> Patch set to Changes Requested.

Thanks for review. I will rebase the remaining patches on top of your
up-to-date tree and resubmit.

As for the patch with vendor specific commands, I will split it into
a separate discussion and make another attempt to convince you, adding
proper description. IIRC there is no generic functionality suitable
for this particular usecase.

Regards,
Sergey

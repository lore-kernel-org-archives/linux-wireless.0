Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:14481 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYH0Hi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 03:38:58 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1491452fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2008 00:38:56 -0700 (PDT)
Message-ID: <1ba2fa240808270038r24d5eeb9l36fd70ef5ae904f5@mail.gmail.com> (sfid-20080827_093905_115008_57FD474D)
Date: Wed, 27 Aug 2008 10:38:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080827013009.GA15781@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080827013009.GA15781@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 27, 2008 at 4:30 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> Dave,
>
> Here is the latest round of fixes intended for 2.6.27.  I think
> the non-iwlwifi ones are pretty solid.  As for the iwlwifi ones,
> the Intel guys assure me that these are important changes.
>
> You will notice that (despite my exhortations) no less than two of
> the iwlwifi patches declare themselves as cleanups.  I have included
> them anyway because the later fixes depend on them and they seemed
> harmless enough.  Plus, they were posted (or at least written) before
> the recent fireworks about what we should be merging after -rc1...
>
PCI cleanup patch is badly named. It fixes PCI registers sizes and ads
one forgotten hw workaround
I called it cleanup because it went through all PCI accesses we have
in the driver.

Scan cleanup was requested because of dependencies but it's harmless,
we can rebase the patches
prefer not it's just waste of time. Afther massive ath9k merge I
didn't see it was a conceptual problem.

Thanks
Tomas

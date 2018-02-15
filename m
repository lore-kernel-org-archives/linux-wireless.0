Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51652 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754805AbeBOHf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 02:35:59 -0500
Message-ID: <1518680151.7832.26.camel@intel.com> (sfid-20180215_083620_473278_3016377C)
Subject: Re: [PATCH 18/20] iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM
 default
From: Luciano Coelho <luciano.coelho@intel.com>
To: Ulf Magnusson <ulfalizer@gmail.com>, linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, tfiga@chromium.org,
        paul.burton@mips.com, m.szyprowski@samsung.com,
        egtvedt@samfundet.no, linus.walleij@linaro.org,
        vgupta@synopsys.com, mgorman@techsingularity.net, hch@lst.de,
        mina86@mina86.com, robh@kernel.org, sboyd@codeaurora.org,
        paulus@ozlabs.org, will.deacon@arm.com, tony@atomide.com,
        npiggin@gmail.com, yamada.masahiro@socionext.com,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 15 Feb 2018 09:35:51 +0200
In-Reply-To: <20180205012146.23981-19-ulfalizer@gmail.com>
References: <20180205012146.23981-1-ulfalizer@gmail.com>
         <20180205012146.23981-19-ulfalizer@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-05 at 02:21 +0100, Ulf Magnusson wrote:
> 'default false' should be 'default n', though they happen to have the
> same effect here, due to undefined symbols ('false' in this case)
> evaluating to n in a tristate sense.
> 
> Remove the default instead of changing it. bool and tristate symbols
> implicitly default to n.
> 
> Discovered with the
> https://github.com/ulfalizer/Kconfiglib/blob/master/examples/list_und
> efined.py
> script.
> 
> Signed-off-by: Ulf Magnusson <ulfalizer@gmail.com>
> ---

Thanks, Ulf!

This is applied in our internal tree and will eventually reach the
mainline, following our usual upstreaming process.

--
Cheers,
Luca.

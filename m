Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F344AC433E6
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Dec 2020 17:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8BA02247F
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Dec 2020 17:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgLWR6n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Dec 2020 12:58:43 -0500
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:36632 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgLWR6n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Dec 2020 12:58:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 195C818045A48;
        Wed, 23 Dec 2020 17:58:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: smell21_3f007b52746a
X-Filterd-Recvd-Size: 2644
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Wed, 23 Dec 2020 17:57:58 +0000 (UTC)
Message-ID: <36399d76993cf04661b4ade819b3245951ae650b.camel@perches.com>
Subject: Re: [PATCH net] MAINTAINERS: remove names from mailing list
 maintainers
From:   Joe Perches <joe@perches.com>
To:     patchwork-bot+netdevbpf@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pv-drivers@vmware.com,
        doshir@vmware.com, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, woojung.huh@microchip.com,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        drivers@pensando.io, snelson@pensando.io, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        bryan.whitehead@microchip.com, o.rempel@pengutronix.de,
        kernel@pengutronix.de, robin@protonic.nl, hkallweit1@gmail.com,
        nic_swsd@realtek.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, linux-kernel@vger.kernel.org,
        corbet@lwn.net
Date:   Wed, 23 Dec 2020 09:57:57 -0800
In-Reply-To: <160869180729.29227.5706578456404319351.git-patchwork-notify@kernel.org>
References: <20201219185538.750076-1-kuba@kernel.org>
         <160869180729.29227.5706578456404319351.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-12-23 at 02:50 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (refs/heads/master):
> 
> On Sat, 19 Dec 2020 10:55:38 -0800 you wrote:
> > When searching for inactive maintainers it's useful to filter
> > out mailing list addresses. Such "maintainers" will obviously
> > never feature in a "From:" line of an email or a review tag.
> > 
> > Since "L:" entries only provide the address of a mailing list
> > without a fancy name extend this pattern to "M:" entries.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net] MAINTAINERS: remove names from mailing list maintainers
>     https://git.kernel.org/netdev/net/c/8b0f64b113d6
> 
> You are awesome, thank you!

I still think this is not a good patch nor mechanism to
show what is generally used as exploders rather than
individuals.

Effectively only individuals can submit patches and so
can be M: Maintainers.

I believe these entries should really use R: Reviewer
entries and keep the descriptive naming content.

The descriptive naming does add value and this patch
loses that value.




Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49E69C3526D
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Dec 2020 20:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23FED235FA
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Dec 2020 20:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgLSUVn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Dec 2020 15:21:43 -0500
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:52270 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727599AbgLSUVn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Dec 2020 15:21:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 8984B837F24A;
        Sat, 19 Dec 2020 20:21:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: trail89_47117a927448
X-Filterd-Recvd-Size: 1890
Received: from perches-mx.perches.com (imap-ext [216.40.42.5])
        (Authenticated sender: webmail@joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sat, 19 Dec 2020 20:21:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 19 Dec 2020 12:20:59 -0800
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
Subject: Re: [PATCH net] MAINTAINERS: remove names from mailing list
 maintainers
In-Reply-To: <20201219185538.750076-1-kuba@kernel.org>
References: <20201219185538.750076-1-kuba@kernel.org>
User-Agent: Roundcube Webmail/1.4-rc2
Message-ID: <53a3855a184f5af5b829065962ae5773@perches.com>
X-Sender: joe@perches.com
X-Originating-IP: [172.58.31.245]
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-12-19 10:55, Jakub Kicinski wrote:
> When searching for inactive maintainers it's useful to filter
> out mailing list addresses. Such "maintainers" will obviously
> never feature in a "From:" line of an email or a review tag.
> 
> Since "L:" entries only provide the address of a mailing list
> without a fancy name extend this pattern to "M:" entries.


As these are not actual people I suggest using
R: entries and not removing the more descriptive names.

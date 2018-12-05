Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCFAC04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 18:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF26220892
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 18:09:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF26220892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbeLESJI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 13:09:08 -0500
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:58495 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727388AbeLESJI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 13:09:08 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 42A72182CF665;
        Wed,  5 Dec 2018 18:09:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: trail98_3239fa3f38115
X-Filterd-Recvd-Size: 1204
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Wed,  5 Dec 2018 18:09:05 +0000 (UTC)
Message-ID: <a8daff3575d4682107dede1f07bf98470acb98ff.camel@perches.com>
Subject: Re: [PATCH] mt76: convert to DEFINE_SHOW_ATTRIBUTE
From:   Joe Perches <joe@perches.com>
To:     Yangtao Li <tiny.windzz@gmail.com>, davem@davemloft.net,
        kubakici@wp.pl, matthias.bgg@gmail.com, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, sgruszka@redhat.com,
        kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Date:   Wed, 05 Dec 2018 10:09:03 -0800
In-Reply-To: <20181203134028.12645-1-tiny.windzz@gmail.com>
References: <20181203134028.12645-1-tiny.windzz@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-12-03 at 08:40 -0500, Yangtao Li wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Thanks.

Are you doing these manually or using some script?



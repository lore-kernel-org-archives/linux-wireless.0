Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59355C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01BFA20835
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:07:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01BFA20835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbeJKReP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 13:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbeJKReP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 13:34:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF47A308AA14;
        Thu, 11 Oct 2018 10:07:40 +0000 (UTC)
Received: from localhost (ovpn-204-112.brq.redhat.com [10.40.204.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 351D96B8F6;
        Thu, 11 Oct 2018 10:07:40 +0000 (UTC)
Date:   Thu, 11 Oct 2018 12:07:39 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: Re: [PATCH 0/4] rt2800: more register programing tweaks
Message-ID: <20181011100738.GB20912@redhat.com>
References: <1539186380-31949-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539186380-31949-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 11 Oct 2018 10:07:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 05:46:16PM +0200, Stanislaw Gruszka wrote:
> This is on top of previous post:
> https://marc.info/?l=linux-wireless&m=153908617400582&w=2
> 
> Stanislaw Gruszka (4):
>   rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band
>   rt2800: enable TX_PIN_CFG_RFRX_EN only for MT7620
>   rt2800: remove unneeded RT6352 check
>   rt2800: comment and simplify AGC init for RT6352
> 
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 37 ++++++++++++++++----------
>  1 file changed, 23 insertions(+), 14 deletions(-)

and drop this one as well.

Thanks
Stanislaw

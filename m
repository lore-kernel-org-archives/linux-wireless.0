Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D73CC04EB8
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 09:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40A5420849
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 09:07:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40A5420849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbeLLJHq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:07:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbeLLJHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 04:07:45 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8EFCDC058CBE;
        Wed, 12 Dec 2018 09:07:45 +0000 (UTC)
Received: from localhost (unknown [10.40.205.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6BB8608C5;
        Wed, 12 Dec 2018 09:07:44 +0000 (UTC)
Date:   Wed, 12 Dec 2018 10:07:43 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        pkshih@realtek.com, tehuang@realtek.com
Subject: Re: [PATCH v2 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20181212090743.GA13331@redhat.com>
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 12 Dec 2018 09:07:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 16, 2018 at 07:31:06PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtw88 supports 8822BE and 8822CE chips, and will be able to support
> multi-vif combinations in run-time.
> 
> For now, only PCI bus is supported, but rtw88 was originally designed
> to optionally support three buses includes USB & SDIO. USB & SDIO modules
> will soon be supported by rtw88, with configurable core module to fit
> with different bus modules in the same time.

Kalle, is here anything that stop the driver being merged ?

Thanks
Stanislaw

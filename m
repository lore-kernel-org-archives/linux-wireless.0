Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36F8C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB89120657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfCKN66 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfCKN66 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:58:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59D08C065866;
        Mon, 11 Mar 2019 13:58:58 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2E7A66824;
        Mon, 11 Mar 2019 13:58:57 +0000 (UTC)
Date:   Mon, 11 Mar 2019 14:58:55 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v7 00/14] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20190311135855.GE6089@redhat.com>
References: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552139302-20476-1-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 11 Mar 2019 13:58:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 09, 2019 at 09:48:08PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtw88 now supports RTL8822BE/RTL8822CE now, with basic station mode
> functionalities. The firmware for both can be found at linux-firmware.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> For RTL8822BE: rtw88/rtw8822b_fw.bin
> For RTL8822CE: rtw88/rtw8822c_fw.bin

I have only some nitpicks for the last version and this queue stop/wake
rece is rather theoretical than practical. All of those can be fixed
by incremental patches, no need to resend new version IMO.

Overall the rtw88 driver looks great to me.

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

Please keep this tag if you would eventually repost (also
Acked-by Greg for remove staging rtlwifi).

Stanislaw


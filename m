Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA829C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 10:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7841820856
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 10:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfA1KQa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 05:16:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbfA1KQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 05:16:30 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38B5A58E51;
        Mon, 28 Jan 2019 10:16:30 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A36A611D4;
        Mon, 28 Jan 2019 10:16:29 +0000 (UTC)
Date:   Mon, 28 Jan 2019 11:12:14 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20190128101214.GC4132@redhat.com>
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <87tvht18mn.fsf@codeaurora.org>
 <F7CD281DE3E379468C6D07993EA72F84D1793BB2@RTITMBSVM04.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1793BB2@RTITMBSVM04.realtek.com.tw>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 28 Jan 2019 10:16:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 09:25:32AM +0000, Tony Chuang wrote:
> > >  - change tree location to wireless-next
> > 
> > What does this mean? wireless-next has not been used for years, do you
> > mean wireless-drivers-next instead?
> > 
> > --
> > Kalle Valo
> 
> Sorry for the typo here. Yes, I mean " wireless-drivers-next ".
> In MAINTAINERS file, I do change to "wireless-drivers-next" instead of "wireless-next".

The git entry in MAINTAINER file is not necessary and should point
the driver specific tree, which rtw88 do not have. Just remove this
entry. Also:

+W:     http://wireless.kernel.org/

is not right and should be removed or replaced by driver specific page.

Please also change topic of 13 patch. Is not "adding support for Realtek
802.11ac wireless chips",  but just adding MAINTAINER entry. 

Thanks
Stanislaw

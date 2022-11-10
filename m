Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1487C433FE
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Nov 2022 07:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiKJHPe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Nov 2022 02:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbiKJHNj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2022 02:13:39 -0500
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDB3C6540;
        Wed,  9 Nov 2022 23:13:35 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 5B02580C7;
        Thu, 10 Nov 2022 07:03:46 +0000 (UTC)
Date:   Thu, 10 Nov 2022 09:13:33 +0200
From:   Tony Lindgren <tony@atomide.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ARM: OMAP2+: pdata-quirks: stop including wl12xx.h
Message-ID: <Y2yknekcTus8CB2J@atomide.com>
References: <20221109224250.2885119-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109224250.2885119-1-dmitry.torokhov@gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Dmitry Torokhov <dmitry.torokhov@gmail.com> [221109 22:33]:
> As of commit 2398c41d6432 ("omap: pdata-quirks: remove openpandora
> quirks for mmc3 and wl1251") the code no longer creates an instance of
> wl1251_platform_data, so there is no need for including this header.

Best to merge this together with the rest of the series:

Acked-by: Tony Lindgren <tony@atomide.com>

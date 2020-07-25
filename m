Return-Path: <SRS0=EDlr=BE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62588C433E4
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 21:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A862070B
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 21:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgGYVDp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 25 Jul 2020 17:03:45 -0400
Received: from smtprelay0013.hostedemail.com ([216.40.44.13]:53398 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728015AbgGYVDp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Jul 2020 17:03:45 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 83030100E7B47;
        Sat, 25 Jul 2020 21:03:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sun63_59013f726f53
X-Filterd-Recvd-Size: 1432
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 21:03:42 +0000 (UTC)
Message-ID: <f7349cdd968aa8e8fa6552d62999a7e05fa875f7.camel@perches.com>
Subject: Re: [PATCH 0/6] rtlwifi: Convert RT_TRACE to rtl_dbg and neatening
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 25 Jul 2020 14:03:41 -0700
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2020-07-25 at 12:55 -0700, Joe Perches wrote:
> RT_TRACE seems like it should be associated to tracing but it's not.
> It's a generic debug logging mechanism.
> Rename it to a more typical name.
> Miscellaneous neatening around these changes.

Patch 1/6 is over 1MB and is too large for some mailing lists.

These patches are based on wireless-drivers-next and are also
available at:

git://repo.or.cz/linux-2.6/trivial-mods.git in branch 20200724_rtlwifi



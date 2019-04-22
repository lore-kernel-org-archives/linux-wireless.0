Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68337C10F11
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 16:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 444C820B1F
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 16:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfDVQHx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 12:07:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:55629 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbfDVQHx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 12:07:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Apr 2019 09:07:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,382,1549958400"; 
   d="scan'208";a="152930294"
Received: from jprestwo-test.jf.intel.com ([10.54.74.49])
  by orsmga002.jf.intel.com with ESMTP; 22 Apr 2019 09:07:52 -0700
Message-ID: <9e8cac221ec049f2359d5fc35de6145a45fbeaaa.camel@linux.intel.com>
Subject: mac80211_hwsim: EXT_FEATURE_CAN_REPLACE_PTK0 ?
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     linux-wireless@vger.kernel.org
Date:   Mon, 22 Apr 2019 09:07:35 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I know for actual hardware drivers this feature requires more than just
the flip of a switch, but is there any technical reason why this is not
turned on in mac80211_hwsim? I know it was added relatively recently,
so maybe mac80211_hwsim just hasn't turned it on yet? If there are no
objections to enabling it, I can send a patch.

Thanks,
James


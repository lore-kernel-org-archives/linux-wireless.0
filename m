Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E57EAC2D0E4
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Nov 2020 11:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843942076E
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Nov 2020 11:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733050AbgKXL4e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Nov 2020 06:56:34 -0500
Received: from mga17.intel.com ([192.55.52.151]:31135 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbgKXL4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Nov 2020 06:56:33 -0500
IronPort-SDR: JKXWGK996ncVQsF7WxapJ4wCvN6jCI09TVUVIQwNnPvxcTCzK3a5DPpqk/B7a2X+HHKZ8My7mt
 GHlLyp8nWVoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9814"; a="151771761"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="151771761"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 03:56:33 -0800
IronPort-SDR: eGu97I91yYzbukAddM6CjtZeXEdks49V4Zm54sLE8PfH6pz/aILQ7P5l/1sqIXN46qiy6CGmtk
 IYfK33QSwUVQ==
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="478475204"
Received: from dohanlon-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.20.97])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 03:56:28 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, ath11k@lists.infradead.org,
        ath10k@lists.infradead.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 4/9] relay: allow the use of const callback structs
In-Reply-To: <20201124094209.GD31963@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1606153547.git.jani.nikula@intel.com> <cc3ff292e4eb4fdc56bee3d690c7b8e39209cd37.1606153547.git.jani.nikula@intel.com> <20201124094209.GD31963@infradead.org>
Date:   Tue, 24 Nov 2020 13:56:25 +0200
Message-ID: <87ft4zm0ie.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 24 Nov 2020, Christoph Hellwig <hch@infradead.org> wrote:
> Otherwise this looks good to me:

v3 sent.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the reviews, appreciated.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center

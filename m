Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24109C433EF
	for <linux-wireless@archiver.kernel.org>; Wed, 29 Jun 2022 17:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiF2RZQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiF2RZQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Jun 2022 13:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF1F3C49E
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2022 10:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15B9961E15
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2022 17:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F91C34114;
        Wed, 29 Jun 2022 17:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656523514;
        bh=QgmluVoFXSlkEquZxV35J0nPPvF64+8WTO/UHudGnBM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZUaXzKsrBU81RMS8IJX07fLGUJjq1EBc1yzn8VMohQlqosN+Si5DZfYKqCawWZi5Y
         kgTfXPU+UaqRoZ9pdmh9mmGp5OGQpReGPQ+ioXkXh9PpX+qSOPDGHym6wB56VqkmoN
         3wui9fLizj7RJMeOWJLtx4jo20ajlykPIICLG6+gjIRwprnOyFuZeufHDuF1LBT6n/
         6XybWwfcqavJpWYiqlYwpA+nHrQKJwbCRZIbBi3rC5lH91DlTzKIEmUyH7x9JPoa8J
         +54yefAAAlM1vSvVfwE7lcT7JDZ61DMSVrX77LsitW25alOODuN910I+GVUAJDfNwI
         Q0dKOogm4xonw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Peter Chiu <chui-hao.chiu@mediatek.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Ryder Lee <ryder.Lee@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 1/2] mt76: mt7915: update mpdu density in 6g capability
References: <20220622012449.17797-1-chui-hao.chiu@mediatek.com>
Date:   Wed, 29 Jun 2022 20:25:10 +0300
In-Reply-To: <20220622012449.17797-1-chui-hao.chiu@mediatek.com> (Peter Chiu's
        message of "Wed, 22 Jun 2022 09:24:48 +0800")
Message-ID: <875ykjpekp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Peter Chiu <chui-hao.chiu@mediatek.com> writes:

> Set mpdu density to 2 usec in 6g capability.
>
> Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>

Why? The commit log should explain that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

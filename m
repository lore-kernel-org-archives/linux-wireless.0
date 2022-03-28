Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9A2C433FE
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Mar 2022 13:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243315AbiC1Nkv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Mar 2022 09:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243309AbiC1Nkt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Mar 2022 09:40:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E72621259;
        Mon, 28 Mar 2022 06:39:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9FEF61130;
        Mon, 28 Mar 2022 13:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42265C004DD;
        Mon, 28 Mar 2022 13:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648474748;
        bh=b2DYrkx9rsufK0KKJFQZ+34er/xvhl0WJyLOoBywmMc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JNSf22WFmvU7HlcMhVVhS8Vn/TF5pKjA3O18XX8+y80tmK0L2oWtVWQk7CnjaHMOd
         o87kYyjEKy73WNuMGuRpeTGQh1jDwxxGPQY0vToK7x4dGVquf6GZ6vv/1pMJH31WpC
         jVLni2vy4RGdgqiSXoT/eM5nGk3qi8qPMUZcY4rVuwdr07jhf0Rx8ERWqXUJqASY5f
         Xidp/+cG4Gzdh3KUzLjbefLnRfYx2XXBpznh4oAqCnwU8yrv56cQIyr+wypYBcciVy
         t2gepn2Do/LqgykXnSNPFR5Q+0xrrA/nbZuWlCDGXogSuJC+WRwRP9GqitYFhUXxzV
         rUPuJh5qwLKcQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     trix@redhat.com
Cc:     toke@toke.dk, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: initialize arrays at compile time
References: <20220328130727.3090827-1-trix@redhat.com>
Date:   Mon, 28 Mar 2022 16:39:02 +0300
In-Reply-To: <20220328130727.3090827-1-trix@redhat.com> (trix's message of
        "Mon, 28 Mar 2022 06:07:27 -0700")
Message-ID: <877d8eyz61.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

The content type on this email was weird:

Content-Type: application/octet-stream; x-default=true

Please resubmit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

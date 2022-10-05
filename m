Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCF8C433FE
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Oct 2022 13:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiJENA4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Oct 2022 09:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiJENAy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2022 09:00:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF041EC7B
        for <linux-wireless@vger.kernel.org>; Wed,  5 Oct 2022 06:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=hrbtrMA98yaupvU5uv1eM8Y+sx8fe/yASba1RDAfi4E=; t=1664974852; x=1666184452; 
        b=JmqNMLZA/VsLBmjRE2yutjs1B3jb3++MVxqEFvObhKwErzhRKgXzf9aXFxiKS4ANSqtArck+Dm5
        47p7OywKe2muuBXP60PqaFhB+CUECXrzvrI1rcmgc+d6N+bL01ePQq4nd47eGCpjfY1Sblfi7lhSV
        /5oKvDa3SaQXZJ9gFWSABYfiV7Xk3wSiSVwHbQ8BQ71gEZIAiW1K+/4IiaC21tW/PjSvEWZGePBYL
        CXms4r7iEWprN7tF74cJSZGeJG3TGpry/Vo706GKREECCm55rvXgMiqE2Kuo/rLQvtp4+WPqnDQpC
        mSft6E23ooz+RJTB1rCUU7dsPCn+inxtt8nA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1og414-00G2RL-1Z
        for linux-wireless@vger.kernel.org;
        Wed, 05 Oct 2022 15:00:50 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 00/28] wifi: further MLO work
Date:   Wed,  5 Oct 2022 15:00:20 +0200
Message-Id: <20221005130048.217341-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Sorry for the long wait. Here (and in the wireless-next tree's
mld branch) is the next set of patches. I've thrown in some
additional patches from our tree just in case something here
has a dependency on it.

This includes (stack) fixes from the interop testing, but more
work will be needed towards the next one.

johannes



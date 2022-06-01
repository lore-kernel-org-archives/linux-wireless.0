Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED54EC433EF
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Jun 2022 07:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343953AbiFAHkF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Jun 2022 03:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241208AbiFAHkD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Jun 2022 03:40:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828519344E
        for <linux-wireless@vger.kernel.org>; Wed,  1 Jun 2022 00:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=wc+SE3Qh/k7ccS7nu6RQaxlCav7HWPbFuEKq5EQkVNk=; t=1654069202; x=1655278802; 
        b=k0dWee9GLBbuYtuO279VGhmd+5f+J8jYXRHVcyirwigaNOHUOVAGhU+hiPKNvn8GT+NzTatalLe
        3KsSrb6H0ueHl9MeFJEN+fOoat1WGF1+J3FzMzXO1Q5HKbvpeAhCOM688eiz6NB0iNlwXd6BXUUK9
        2+W8WQAeg4uwJ45vMKZdnUIbEjJaobmau6v8fLrt5LLIiABggPCnPyXrV/t10BGfMSHrHs8joUfM3
        YsDXQTzAJBXLJ1kdc+9wWjqCJtUBqjCY/cTCljp6KIul3l5kgG3wvAJ9Jx4VLjBu/onW7oOaBtWC3
        5ymxbKSj9n2kGZrPk15yJEtT24Ohvo9pM1Nw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nwIxU-00AJPK-Tl
        for linux-wireless@vger.kernel.org;
        Wed, 01 Jun 2022 09:40:01 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 00/15] mac80211 MLO updates
Date:   Wed,  1 Jun 2022 09:39:43 +0200
Message-Id: <20220601073958.8345-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Here's the next (large) set of mac80211 MLO updates, though it's of
course still _far_ from complete :-)

Next on my list:
 - auth/assoc
 - datapath

johannes



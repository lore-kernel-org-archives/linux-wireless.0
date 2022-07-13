Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9EAC43334
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Jul 2022 15:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbiGMPel (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiGMPek (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jul 2022 11:34:40 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D542FFE0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2022 08:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=HG7y0ESzg/HVXf11y4m8ABJsFjuKCK9fZ6cL9kZRp64=; t=1657726479; x=1658936079; 
        b=r8YzTsIHOZ+Ex4TyImXu+lkHJPRhVsny8Wx2DyXB80qc8OwViIjsE6BgVBHM2d+QZM9EPQOgdY1
        8lrbo2bcC11Hh0Mp152s/Y4IJfQjCMwh0E/iOmw4s9safWgQ7KsLUnoL0AlDh7KEb6T+bfVPr6Qrq
        zeipfoEDEHvCUw1FiQ4DORDSj1DlEW6aRh5EXHV0zWQZyecaPoNEiJYBg+lrLNTsTC9f3PV8j4XU/
        EDBbXGRVdwWdwQWN7SiSKi9yFJT98zXAMZqCFJZdI2RdybKdctp6PNcTpq99ADGkZkj98+CnMVJ4i
        qOB8qR37doD8Jw2IHhXfy6Mv6nLh2zpm0sXg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oBeNp-00EnaA-AR
        for linux-wireless@vger.kernel.org;
        Wed, 13 Jul 2022 17:34:37 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 00/21] wifi: client-side MLO preparations
Date:   Wed, 13 Jul 2022 17:34:12 +0200
Message-Id: <20220713153433.279227-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Next patch dump, this time with client-side MLO preparations.

The key portions here are still missing, so this is all fairly
much obvious refactoring.

After another round of internal fixes/reviews I'll probably
send out the auth/assoc patch for mac80211 (and some hwsim
bits) next, but possibly limited to a single link for now.

johannes



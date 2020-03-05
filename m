Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B04C3F2CD
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 14:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6699920732
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 14:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgCEO5K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:57:10 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:35768 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgCEO5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 09:57:10 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j9rvx-001JyE-2p; Thu, 05 Mar 2020 15:57:09 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/4] wmediumd vhost-user
Date:   Thu,  5 Mar 2020 15:56:51 +0100
Message-Id: <20200305145655.67427-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

This adds vhost-user support, to match the hwsim code I
just sent to the list.

It also matches the user-mode Linux time-travel=ext:...
code that I previously sent (but hasn't been applied).

It imports a fair portion of the "user space firmware
simulation testing library" that I'm going to release
soon, which also contains the remaining bits for running
such a time-travel simulation.

johannes



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:42813 "EHLO
        smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755815AbcK3KkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 05:40:11 -0500
Received: from smtp04.msg.oleane.net ([172.17.20.113])
        by smtp-out03.msg.oleane.net with ESMTP id uAUAe7M9003605
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 11:40:08 +0100
Received: from RD8 ([195.6.104.67]) (authenticated)
        by smtp04.msg.oleane.net (MSA) with ESMTP id uAUAJaVT027727
        for <linux-wireless@vger.kernel.org>; Wed, 30 Nov 2016 11:19:36 +0100
From: "voncken" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Subject: Atheros ETSI DFS pattern
Date: Wed, 30 Nov 2016 11:19:36 +0100
Message-ID: <012101d24af3$40bb97f0$c232c7d0$@acksys.fr> (sfid-20161130_114015_897243_AD19DB98)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the file drivers/net/wireless/ath/dfs_pattern_detector.c we can found the
ETSI pattern definition.

In this definition we can found 7 patterns (0 to 6).

The ETSI standard EN 301893 Annex D only specifies 6 patterns. Only the
pattern 1 to 6 defined in the ath dfs pattern match with the ETSI standard.

Why the pattern 0 is defined?

Is it possible to remove this pattern and keep compliant with the ETSI
standard?

Thanks for your help.

Cedric.

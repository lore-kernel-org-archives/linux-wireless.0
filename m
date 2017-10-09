Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36436 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751635AbdJIJuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 05:50:22 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <johannes@sipsolutions.net>)
        id 1e1UhZ-0005jA-HI
        for linux-wireless@vger.kernel.org; Mon, 09 Oct 2017 11:50:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/4] built-in regulatory database
Date: Mon,  9 Oct 2017 11:50:14 +0200
Message-Id: <20171009095018.5289-1-johannes@sipsolutions.net> (sfid-20171009_115031_306127_99E9D381)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a new version of these patches, hopefully the final. I changed
the database format to make it smaller
 * dropping antenna gain limitation (never used in db.txt)
 * make CAC timeout in seconds, and optional
 * change length fields to u8
 * change n_rules field to u8
 * re-pack those flags that are used in db.txt

The whole database is now only about 3.4KB.

johannes

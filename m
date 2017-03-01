Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35732 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdCAOQT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 09:16:19 -0500
Received: by mail-io0-f180.google.com with SMTP id j18so31594287ioe.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Mar 2017 06:15:38 -0800 (PST)
Received: from hash (CPE0018e7fe5281-CM18593342f28f.cpe.net.cable.rogers.com. [99.236.145.239])
        by smtp.gmail.com with ESMTPSA id l33sm310656iod.8.2017.03.01.06.15.36
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2017 06:15:37 -0800 (PST)
Received: from bob by hash with local (Exim 4.84_2)
        (envelope-from <me@bobcopeland.com>)
        id 1cj51d-00071q-La
        for linux-wireless@vger.kernel.org; Wed, 01 Mar 2017 09:14:41 -0500
Date: Wed, 1 Mar 2017 09:14:41 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Subject: Deleting old wireless-testing tags
Message-ID: <20170301141441.GA26151@localhost> (sfid-20170301_151951_907053_E17DB639)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

wireless-testing will resume again next week when the merge window opens,
and with 203 w-t tags since I started maintaining it a little over a year
ago, it's about time for some house-keeping.  I plan to delete some of the
older tags in the kernel.org copy.

Before I do so, quick straw poll of anyone using this kernel: are there
specific tags I should keep, or any specific time period I should keep them
around?

E.g. I believe lede/openwrt are using compat-wireless builds generated from
wireless-testing; it might be worth retaining those particular tags just for
reference.  I guess a few folks may be using it as a development tree and
would want a couple of kernel release cycles maintained, and so on.

-- 
Bob Copeland %% http://bobcopeland.com/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:36456 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750845AbcJBQK0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Oct 2016 12:10:26 -0400
Received: by mail-qt0-f177.google.com with SMTP id m5so14966852qtb.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Oct 2016 09:10:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473188728-14995-1-git-send-email-twp@qca.qualcomm.com>
References: <1473188728-14995-1-git-send-email-twp@qca.qualcomm.com>
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Mon, 3 Oct 2016 00:03:45 +0800
Message-ID: <CAEFj986nVFxhMv6hWuvfdOODGsOO-+Zv2=S0BZa6XrL=-W+NUA@mail.gmail.com> (sfid-20161002_181031_030467_8182D3F0)
Subject: Re: [PATCH] ath10k: enable peer stats by default
To: Thomas Pedersen <twp@qca.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Thomas

On Wed, Sep 7, 2016 at 3:05 AM, Thomas Pedersen <twp@qca.qualcomm.com> wrote:
> IFTYPE_MESH_POINT need to rely on these for accurate path
> selection metrics. Other modes will probably also find

Both get expected throughput or get txrate are not available to
mac80211. So, is this useful by enabling it?

----
Chun-Yeow

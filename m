Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:40273 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3DEIVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:21:07 -0400
Received: by mail-ia0-f182.google.com with SMTP id u8so2980489iag.13
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 01:21:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
Date: Fri, 5 Apr 2013 10:21:06 +0200
Message-ID: <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com> (sfid-20130405_102119_052359_A314ADB6)
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio,

On Thu, Apr 4, 2013 at 9:57 PM, Antonio Quartulli <antonio@open-mesh.com> wrote:
> This new API is aimed to let other modules in the kernel
> fetch the maximum throughput value towards a peer over
> a given VIF.

Just curios, what's the intended use for this?

Thanks,
Helmut

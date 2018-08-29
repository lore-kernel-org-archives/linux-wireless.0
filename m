Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:35766 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbeH2K62 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 06:58:28 -0400
Message-ID: <1535526175.5215.4.camel@sipsolutions.net> (sfid-20180829_090306_824971_5B8A1E3B)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander@wetzel-home.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Aug 2018 09:02:55 +0200
In-Reply-To: <e75b4c84-2183-8f77-e9ca-38950a2b3cdc@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
         <20180814104255.4183-2-alexander@wetzel-home.de>
         <1535446026.5895.5.camel@sipsolutions.net>
         <4cc30aa2-6235-f76c-485f-48fac8af3c1a@wetzel-home.de>
         <1535472226.5895.58.camel@sipsolutions.net>
         <e75b4c84-2183-8f77-e9ca-38950a2b3cdc@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-28 at 21:02 +0200, Alexander Wetzel wrote:

> My current preference is how the patch v6 is working and I'm quite sure
> there is no acceptable way to trick the userspace.
> Am I wrong here and we should try something different?

No, you're probably right. I'll take this as it is per your decision,
and will perhaps think about it (and if needed send an RFC patch) later.

johannes

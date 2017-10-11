Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:54444 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757497AbdJKTly (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 15:41:54 -0400
Received: by mail-pf0-f180.google.com with SMTP id m28so1786911pfi.11
        for <linux-wireless@vger.kernel.org>; Wed, 11 Oct 2017 12:41:54 -0700 (PDT)
Date: Wed, 11 Oct 2017 12:41:50 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Ananthapadmanabha <karthida@marvell.com>
Subject: Re: [PATCH] mwifiex: Random MAC address during scanning
Message-ID: <20171011194148.GA84547@google.com> (sfid-20171011_214231_282764_38B8825E)
References: <1506682390-27716-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1506682390-27716-1-git-send-email-gbhat@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 29, 2017 at 04:23:10PM +0530, Ganapathi Bhat wrote:
> From: Karthik Ananthapadmanabha <karthida@marvell.com>
> 
> Driver will advertise RANDOM_MAC support only if the device
> supports this feature.
> 
> Signed-off-by: Karthik Ananthapadmanabha <karthida@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

I'd just like to point out that this is a very bad commit subject:

"[PATCH] mwifiex: Random MAC address during scanning"

It's borderline wrong, really. "Random MAC address during scanning" is
already supported. This patch is just adding a feature-flag check for
it, since some firmwares in the wild don't support it. A more accurate
description would be something like:

"[PATCH] mwifiex: Add feature flag support for MAC randomization"

The patch is already applied, so I'd only worry about it for future
submissions (no need to resend).

Brian

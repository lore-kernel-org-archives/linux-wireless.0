Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47676 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdKMJXL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:23:11 -0500
Message-ID: <1510564989.30497.5.camel@sipsolutions.net> (sfid-20171113_102443_654029_1D038DF4)
Subject: Re: [PATCH v2 3/4] cfg80211: reg: remove support for built-in regdb
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Date: Mon, 13 Nov 2017 10:23:09 +0100
In-Reply-To: <5392a1bb-378c-17c6-de0d-862e86041c2e@uni-rostock.de>
References: <20171009095018.5289-1-johannes@sipsolutions.net>
         <20171009095018.5289-4-johannes@sipsolutions.net>
         <5392a1bb-378c-17c6-de0d-862e86041c2e@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-13 at 10:19 +0100, Benjamin Beichler wrote:
> 
> Is there already an example regulatory.db file available? 

There isn't yet, Seth?

> And is there already a tool chain for creating the new format?

I posted a patch:
https://patchwork.kernel.org/patch/9992477/
for the regdb project.

> I don't see any
> corresponding commit on
> https://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git/
> for your change. Or can I simply use the regulartory.bin as firmware file?

No, you have to make a new file.

johannes

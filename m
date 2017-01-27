Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37140 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751272AbdA0VA2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 16:00:28 -0500
Message-ID: <1485550820.14579.2.camel@sipsolutions.net> (sfid-20170127_220054_043953_5ABC0D3C)
Subject: Re: [PATCH] cfg80211 debugfs: Cleanup some checkpatch issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Pichugin Dmitry <smokeman85@gmail.com>, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2017 22:00:20 +0100
In-Reply-To: <20170127192603.GA13522@gmail.com> (sfid-20170127_203712_578214_221D21FF)
References: <20170127192603.GA13522@gmail.com>
         (sfid-20170127_203712_578214_221D21FF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-27 at 22:26 +0300, Pichugin Dmitry wrote:
> This fixes the checkpatch.pl warnings:
> * Macros should not use a trailing semicolon.
> * Spaces required around that '='.
> * Symbolic permissions 'S_IRUGO' are not preferred.
> * Macro argument reuse 'buflen' - possible side-effects

I really see no point in any of this.

johannes

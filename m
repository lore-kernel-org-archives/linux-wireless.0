Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6138EB64DD
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Jul 2023 12:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjGFMda (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Jul 2023 08:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjGFMdZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2023 08:33:25 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAC91BF0;
        Thu,  6 Jul 2023 05:33:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 99EAF67373; Thu,  6 Jul 2023 14:33:06 +0200 (CEST)
Date:   Thu, 6 Jul 2023 14:33:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     syzbot <syzbot+dfe2fbeb4e710bbaddf9@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, brauner@kernel.org, davem@davemloft.net,
        edumazet@google.com, hare@suse.de, hch@lst.de,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [wireless?] WARNING in restore_regulatory_settings (2)
Message-ID: <20230706123306.GA12417@lst.de>
References: <0000000000001432c105ffcae455@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001432c105ffcae455@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jul 05, 2023 at 10:35:58PM -0700, syzbot wrote:
> The issue was bisected to:

I suspect this bisection would benefit from a re-run, as thecode is
entirely unrelated.


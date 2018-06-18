Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49514 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755175AbeFRHHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 03:07:43 -0400
Message-ID: <1529305659.3490.0.camel@sipsolutions.net> (sfid-20180618_090757_568696_0D6D8CDD)
Subject: Re: linux-next: manual merge of the mac80211-next tree with Linus'
 tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Date: Mon, 18 Jun 2018 09:07:39 +0200
In-Reply-To: <20180618112943.4ceadf24@canb.auug.org.au>
References: <20180618112943.4ceadf24@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-06-18 at 11:29 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the mac80211-next tree got a conflict in:
> 
>   net/mac80211/scan.c
> 
> between commit:
> 
>   6396bb221514 ("treewide: kzalloc() -> kcalloc()")
> 
> from Linus' tree and commit:
> 
>   b9771d41aee7 ("mac80211: support scan features for improved scan privacy")
> 
> from the mac80211-next tree.

Thanks Stephen!

I guess there isn't all that much I can do, unless davem pulls Linus's
tree in and then I can pull his and resolve it. We'll see.

johannes

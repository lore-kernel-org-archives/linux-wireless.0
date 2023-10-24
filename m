Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AD3C07545
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Oct 2023 21:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344278AbjJXVBt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Oct 2023 17:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjJXVBt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2023 17:01:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD7110D4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Oct 2023 14:01:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12266C433C7;
        Tue, 24 Oct 2023 21:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698181307;
        bh=TVlF1/2MJ7xZUzjhJFu4LnvWKWs48xpN8h1PgxxtS64=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AC/NkxZL3+Sk6WNfQdShS5gxiJFcOe4Zp7o8cG99ySJo/bCENispe8TeiLGADm2EE
         O4iql66lPrSC+stz5deahh41g2YR06RPYF8dykvYSSw9R+xT7UH4DaZoU7YgAsi85E
         D+5KVR0nTswBF8V/vKqthYPEHgOPoK7GN4faxjc58oE0I/6lHOL1N+WPgjR5w+inc2
         1m142jFEYwTagmSijxORP7/yZ0cryOy+QnBcRFT1djedTSmYrrTfW7iBmMksYf7X6G
         zUQ3M3dGdVaQATW/diVXb+c1UEga+YmwkRoQ8FeFUYlRIA62/7/U0bG0AgPP7Fgvid
         nOmtUzJZXlF9Q==
Date:   Tue, 24 Oct 2023 14:01:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-2023-10-24
Message-ID: <20231024140146.0d756a96@kernel.org>
In-Reply-To: <f53b015defece9c4b29fbecfaa6fc50d2f299a39.camel@sipsolutions.net>
References: <20231024103540.19198-2-johannes@sipsolutions.net>
        <169817882433.2839.2840092877928784369.git-patchwork-notify@kernel.org>
        <1020bbec6fd85d55f0862b1aa147afbd25de3e74.camel@sipsolutions.net>
        <20231024135208.3e40b69a@kernel.org>
        <f53b015defece9c4b29fbecfaa6fc50d2f299a39.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 24 Oct 2023 22:54:50 +0200 Johannes Berg wrote:
> > > If not, I can resolve this conflict and we'll include it in the next
> > > (and last) wireless-next pull request, which will be going out Thursday
> > > morning (Europe time.)  
> > 
> > Sounds good! But do you need to do the resolution to put something 
> > on top? Otherwise we can deal with the conflict when pulling.  
> 
> No, not really, nothing left that's not in wireless-next already (I
> think), except maybe some tiny cleanups.
> 
> Just trying to make it easier for you, even if it's really not a complex
> conflict :)

I think "Linus rules" would dictate that cross-merges to hide conflicts
are a bad thing. We don't have much to win so let's stick to that :)

Hopefully I can deal with the resolution, but if you want to be 100%
sure - you can drop a git-rerere resolution somewhere I can fetch it.

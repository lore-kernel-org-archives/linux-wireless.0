Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F49E7544F
	for <linux-wireless@archiver.kernel.org>; Tue,  3 Oct 2023 11:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbjJCLpG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 3 Oct 2023 07:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbjJCLpF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2023 07:45:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75276D7;
        Tue,  3 Oct 2023 04:44:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C81BC433CA;
        Tue,  3 Oct 2023 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696333497;
        bh=k8cnobPkdVCXeL3c8IKKmK6W+O4lcf9poakgRi8Q4mE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NmyTUB1WTn44SqKX34+R/3bQCESFttPRwerLBsQmUeWf0ksD8Hlfxk9Z58SfiN9XG
         EQQps3KIljJGcM2yV4KKiQWl3z5PEuG4op1EGbZJAOy2KxW/AWWmmvKYRH52MpDeBz
         0CWNQXeJ3nk0LuUO98cbNIEFJUUwUmrM/4yh06U5xHefT96Wm3C27T/HKBoWPFK1HL
         in98r3GCpcJQQwxndgcRdwESA4o0WF+xfZB9Q7mQTBsk03GxNkj5V0PEhXB9sZyZ9R
         hKFmCnH6xWuG22pS+Bmr6AJpJXx1VQYQYDpp+dM64meijrBltgf2BoA2hrFh09WjH+
         C9Si+DKep1UHg==
Date:   Tue, 3 Oct 2023 13:44:52 +0200
From:   Simon Horman <horms@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] wifi: nl80211: fix doc typos
Message-ID: <ZRv+tGSZaH+GmTTt@kernel.org>
References: <20231001191633.19090-1-rdunlap@infradead.org>
 <20231001191633.19090-3-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231001191633.19090-3-rdunlap@infradead.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Oct 01, 2023 at 12:16:33PM -0700, Randy Dunlap wrote:
> Correct some typos.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Simon Horman <horms@kernel.org>


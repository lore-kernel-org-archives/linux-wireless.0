Return-Path: <SRS0=NAPm=EF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D057C4742C
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Oct 2020 20:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F8AD208B6
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Oct 2020 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604091161;
	bh=BiO5inEJsbbt1UVjJttkrLIDSV3oE240An0AXJLSuMs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=ZPUt+6yJo2eTRZ9UNm63w6cWmF8q0ctLuIxGYMFZ2sEfLDK8QNG26X18TUCTq7pf1
	 /jbXdHZVeOBGAqkaXr3L26keiS5YJ33r7ViJD2VTN7h+fb1UijUAzYlNaMxSUOuF1z
	 MyNySwlgxysYatsD7f+KNbkDF8ezJKqSrczTUz1c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgJ3Uwj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Oct 2020 16:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgJ3Uwj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Oct 2020 16:52:39 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F345206CB;
        Fri, 30 Oct 2020 20:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604091158;
        bh=BiO5inEJsbbt1UVjJttkrLIDSV3oE240An0AXJLSuMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zFPAJYUAn64w5t3oQiuPC/rAV58SzDpCKHg4B7ox1w7ZjHiu2dNk8VvekCaYXmntp
         y1vF3jgQhDKfzg4Y58oqt0DjonU6zWa+6y12kDnUN7GkbwGmMM6RPZBn5KXaWpyeak
         JEKjfEcy1/WGl3ypzunWRYGGIUYp0khvqMSYo/zo=
Date:   Fri, 30 Oct 2020 13:52:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2020-10-30
Message-ID: <20201030135237.129a2cfe@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030094349.20847-1-johannes@sipsolutions.net>
References: <20201030094349.20847-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 30 Oct 2020 10:43:48 +0100 Johannes Berg wrote:
> Hi Jakub,
> 
> Here's a first set of fixes, in particular the nl80211 eapol one
> has people waiting for it.
> 
> Please pull and let me know if there's any problem.

Two patches seem to have your signature twice, do you want to respin?
It's not a big deal.

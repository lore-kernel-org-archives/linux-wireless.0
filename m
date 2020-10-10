Return-Path: <SRS0=cbTT=DR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6F3C433DF
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Oct 2020 23:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFFA620760
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Oct 2020 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602371751;
	bh=889E+muKmUZWiXCo0NGDbO8S8dMIHI5hcTZm7Il+FH0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=DGfDsJSxFI/Y1QgfkDoDVfvN4y+EJSTpRpPGfCGyKi2WcTcYF14GA+5b/msmca1XN
	 IL7EwA2XVx4JFs07+ABnWVe8rKEL+C1T7tkfw9YXxaNPBfi6D4fJmdyVnWNuMc2ozM
	 h2L0eX0gyX90n4rMJJB4ctmqKrbRzxbM/cpkpr0w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgJJWwp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731440AbgJJTWZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Oct 2020 15:22:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5427B223FD;
        Sat, 10 Oct 2020 16:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602347777;
        bh=889E+muKmUZWiXCo0NGDbO8S8dMIHI5hcTZm7Il+FH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=juNFMPwcCmEIIz4e/ZQQhYt+30XfWe2M2uI5XP7/y6XPigSqnSjYn0bKl/UJx7Ur1
         VDlRRJFOjbYIFXQpD7i4vAylTgsY0GEWWSuWyyFA4ZAtyjI97CC6zOepdVh0ymmgr0
         8BFcg82UDVq8b3/XOszd6DPZ8k8KJ1y06lA9n1CA=
Date:   Sat, 10 Oct 2020 09:36:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2020-10-08
Message-ID: <20201010093615.107632f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008104204.44106-1-johannes@sipsolutions.net>
References: <20201008104204.44106-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu,  8 Oct 2020 12:42:03 +0200 Johannes Berg wrote:
> Hi Dave,
> 
> And also a few more patches for net-next, mostly fixes
> for the work that recently landed there.
> 
> Please pull and let me know if there's any problem.

.. aand pulled, thanks!

Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB0FC5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED1C120644
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 08:10:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED1C120644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbeJRQKY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 12:10:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbeJRQKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 12:10:24 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED0CF9D504;
        Thu, 18 Oct 2018 08:10:35 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8488368725;
        Thu, 18 Oct 2018 08:10:35 +0000 (UTC)
Date:   Thu, 18 Oct 2018 10:10:34 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless workshop (was: Re: Announcing Netdev 0x13 conference)
Message-ID: <20181018081033.GA2190@redhat.com>
References: <6cab0b49-a6f3-65c5-f371-1f8c7d4325bb@mojatatu.com>
 <1539080903.3687.111.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539080903.3687.111.camel@sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 18 Oct 2018 08:10:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 09, 2018 at 12:28:23PM +0200, Johannes Berg wrote:
> Kalle and I have (more or less) decided to propose a wireless workshop
> for Netdev 0x13.
> 
> In order to gauge interest and plan room size, can you reply (privately
> if you like) if this would work for you and you'd (want to) attend?

I plan to attend.

Thanks
Stanislaw

Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E60C43460
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 18:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F7876108B
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Apr 2021 18:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhDISFt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:05:49 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:19534 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhDISFs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Apr 2021 14:05:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617991535; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=2SkuAsfrlt4Osp8J6LdA1xk/C7laqmigElesvJfYqng=;
 b=aXgVVDv4Amd1kv71xdU2znC05BrT+JkZ4y1wqPG/gOH9gRGJtJzNz/WmTxt7J/gTmuukqLp8
 AXI8H4U4h0BJw8RJByrHfiWDEX/dgcJjxg/aRpCRB+Je+fi6YEk6kdsM1KtC2DT8kUkNMJt6
 /p1N41/6v8cXJGqrSySdIvKnUiE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6070975f9a9ff96d959f7afa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 09 Apr 2021 18:05:19
 GMT
Sender: alokad=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 99E92C433ED; Fri,  9 Apr 2021 18:05:19 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alokad)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 64E1EC433CA;
        Fri,  9 Apr 2021 18:05:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 09 Apr 2021 11:05:19 -0700
From:   Aloka Dixit <alokad@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9 0/4] Multiple BSSID support
In-Reply-To: <19bb13db617309106091d485c7218cd0ee7bace7.camel@sipsolutions.net>
References: <20210310182604.8858-1-alokad@codeaurora.org>
 (sfid-20210310_192727_681722_4BC25758)
 <19bb13db617309106091d485c7218cd0ee7bace7.camel@sipsolutions.net>
Message-ID: <b34bd75aa9723bf3b83254d3296ea97b@codeaurora.org>
X-Sender: alokad@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2021-04-08 04:53, Johannes Berg wrote:
> On Wed, 2021-03-10 at 10:26 -0800, Aloka Dixit wrote:
>> This patchset adds support for multiple BSSID and
>> enhanced multi-BSSID advertisements.
> 
> All of this, in particular the subjects, should really mention that 
> it's
> for AP side.
> 
> Does it apply also for mesh, btw?
> 
> johannes

No, this patchset is only for AP mode.
Will mention it in the titles/commit_logs/comments.
Thanks.

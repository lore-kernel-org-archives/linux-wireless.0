Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E3BC5519F
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Nov 2020 06:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63AE522256
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Nov 2020 06:19:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2Tk6spH/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKTGSc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Nov 2020 01:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:33722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgKTGSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Nov 2020 01:18:31 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B12F722256;
        Fri, 20 Nov 2020 06:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605853110;
        bh=kgE8YnXPz2O7Fw8Fqo+KnJOVq5kmPwWw1fm7scPoKek=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2Tk6spH/euf2l13zEbaiYj9BSnEnxkVir9xnmS5rYL517pYEs1IsURM6C7E7eEaI7
         5eh5Am13VXooLn8PWSP1rIvd0bl/vj/+5M1Bz7wULZB71w8aQXb9ptxrF0hG0ZFaoe
         AaBA5bIciI+yPvd8pKQ2ssZtG1PdvvJpYydLR3+c=
Date:   Thu, 19 Nov 2020 22:18:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Bhaumik Bhatt <bbhatt@codeaurora.org>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, cjhuang@codeaurora.org,
        linux-arm-msm@vger.kernel.org, hemantk@codeaurora.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org,
        clew@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Unprepare MHI channels during remove
Message-ID: <20201119221828.72ba151a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201120061512.GB3909@work>
References: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
        <20201119211046.64294cf6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201120061512.GB3909@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 20 Nov 2020 11:45:12 +0530 Manivannan Sadhasivam wrote:
> Jakub, can you please provide your ack so that I can take it?

Sure:

Acked-by: Jakub Kicinski <kuba@kernel.org>

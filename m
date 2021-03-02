Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C83C433DB
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Mar 2021 00:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D1AE64F9A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Mar 2021 00:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbhCCA3J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Mar 2021 19:29:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351082AbhCBVmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Mar 2021 16:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2082A601FB;
        Tue,  2 Mar 2021 21:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614721324;
        bh=vExVERiAK+CqKVzzo6VrQtfRSSKKna3ICtCV3SbMyqk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O+IDDm/aSFMAbrcQjJksklCWsvlpPYEXUlB/erhQioHEFsxWjP7i6Jxm9KEdllsKr
         dBThDAv/AQ+qwkDNHmkSGTlFzmrwHxHHL5C+nGvmEos6WhE4z5xDr+AA+/34XZCpeq
         YX19BpLV3rRxlEaizamDF+wXkPTfUx+TIYGM9JaQa7JXrgwF6kxeRJbd1VsqL13Uli
         AZoZFtwFMdyfst/19j9ZIIbVHvvE9nTvDrVQtT2anAhipHUinc75he0DjIoK5Z9Pyl
         CubZwprb6NlGYUGxdwqADzx8xLc4ZdTmRCuuBuhJocyUnZT2oarE0m8lDQeHI/JjuR
         Z8cyylpDXnfuQ==
Date:   Tue, 2 Mar 2021 13:42:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     "Coelho\, Luciano" <luciano.coelho@intel.com>,
        "nathan\@kernel.org" <nathan@kernel.org>,
        "gil.adam\@intel.com" <gil.adam@intel.com>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "weiyongjun1\@huawei.com" <weiyongjun1@huawei.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Goodstein\, Mordechay" <mordechay.goodstein@intel.com>,
        "hulkci\@huawei.com" <hulkci@huawei.com>,
        "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id
 tables
Message-ID: <20210302134203.4ee50efe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <877dmp8hdx.fsf@codeaurora.org>
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
        <20210226210640.GA21320@MSI.localdomain>
        <87h7ly9fph.fsf@codeaurora.org>
        <bd1bd942bcccffb9b3453344b611a13876d0e565.camel@intel.com>
        <20210302110559.1809ceaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <877dmp8hdx.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 02 Mar 2021 21:50:18 +0200 Kalle Valo wrote:
> > if Wei doesn't respond could you please step in to make sure this
> > fix is part of Dave's next PR to Linus?  
> 
> Will do. Related to this, what's your pull request schedule to Linus
> nowadays? Do you submit it every Thursday?

Fair question :) Dave is back full time now, so I think it will be more
merit based again.

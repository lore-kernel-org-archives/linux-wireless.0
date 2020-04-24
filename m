Return-Path: <SRS0=Yp73=6I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27724C54FD0
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Apr 2020 13:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B17620736
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Apr 2020 13:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgDXNev (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Apr 2020 09:34:51 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:57842 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726489AbgDXNev (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Apr 2020 09:34:51 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jRyTg-000OVP-6S; Fri, 24 Apr 2020 16:34:48 +0300
Message-ID: <976feef86e2bf266cb98108e5e361f3a329054b9.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date:   Fri, 24 Apr 2020 16:34:46 +0300
In-Reply-To: <f786da13f1f1bb41e6a5c38125cde4cc8d67e91c.camel@coelho.fi>
References: <f786da13f1f1bb41e6a5c38125cde4cc8d67e91c.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: pull-request: iwlwifi-next 2020-04-24
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2020-04-24 at 14:02 +0300, Luca Coelho wrote:
> Hi Kalle,
> 
> Here's the first batch of patches intended for v5.8.  This includes
> the last two patchsets I sent out.  Usual development work.  More
> details about the contents in the tag description.
> 
> Please let me know if there are any issues.

Ooops, I accidentally send v1 of one patch that had a v2.  Please,
ignore this pull request, I'll send a new one.

--
Cheers,
Luca.


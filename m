Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41276 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754622AbeEHTtT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 15:49:19 -0400
Received: from mail-io0-f197.google.com ([209.85.223.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fG8bt-0004yS-U9
        for linux-wireless@vger.kernel.org; Tue, 08 May 2018 19:49:18 +0000
Received: by mail-io0-f197.google.com with SMTP id u23-v6so12128142ioc.13
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 12:49:17 -0700 (PDT)
Date: Tue, 8 May 2018 14:49:15 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Haim Dreyfuss <haim.dreyfuss@intel.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [PATCH v2 1/2] wireless-regdb: Add wmm rule for EEA and EFTA
 countries
Message-ID: <20180508194915.GA3375@ubuntu-xps13> (sfid-20180508_214923_746310_ECBCF3BF)
References: <1525363103-8620-1-git-send-email-haim.dreyfuss@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525363103-8620-1-git-send-email-haim.dreyfuss@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2018 at 06:58:22PM +0300, Haim Dreyfuss wrote:
> The ETSI EN 301 893 v211 (2017-05) standard defines a new channel
> access mechanism that all devices (WLAN and LAA) need to comply with.
> In previous versions the device was allowed by ETSI to implement
> 802.11 channel access mechanism based on a set of priority classes
> which are taken from 802.11.
> According to the new standard there might be some exception
> which require the EEA and the EFTA countries, which adhere
> ETSI rules, to follow more restrictive rules.
> In order to comply with the new standard introduced by ETSI, add
> wmmrule global item with the new ETSI channel mechanism rules.
> Also add wmmrule flag to EEA and EFTA countries.
> 
> Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>

That's looking better. I did some light testing and nothing blew up with
4.15 or 4.17.

Applied both patches, thanks!

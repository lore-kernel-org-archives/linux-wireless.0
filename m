Return-Path: <SRS0=e8Py=RI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268F3C43381
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 08:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9C4B20675
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Mar 2019 08:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfCEIqP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:46:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:58659 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfCEIqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Mar 2019 03:46:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2019 00:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,443,1544515200"; 
   d="scan'208";a="121078788"
Received: from kphartnx-mobl1.ger.corp.intel.com ([10.252.28.244])
  by orsmga006.jf.intel.com with ESMTP; 05 Mar 2019 00:46:11 -0800
Message-ID: <82688839050d37fa1567205c236328da91a092e9.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: fix 64-bit division
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Tue, 05 Mar 2019 10:46:09 +0200
In-Reply-To: <CAK8P3a3ziTxhEW5ea828jNjktR9qH-T2OknON5RVBrbiXT4kBw@mail.gmail.com>
References: <20190304203924.2111146-1-arnd@arndb.de>
         <ec4e92fa787a7db1caf39920a62c3721849baee9.camel@intel.com>
         <CAK8P3a3ziTxhEW5ea828jNjktR9qH-T2OknON5RVBrbiXT4kBw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-03-05 at 09:37 +0100, Arnd Bergmann wrote:
> On Tue, Mar 5, 2019 at 7:44 AM Luciano Coelho <
> luciano.coelho@intel.com> wrote:
> > On Mon, 2019-03-04 at 21:38 +0100, Arnd Bergmann wrote:
> > This was already fixed with this patch:
> > 
> > https://patchwork.kernel.org/patch/10823267/
> > 
> > ...but it hasn't reached the mainline yet.
> > 
> > I'm planning to send it to the v5.1-rc series as soon as the merge
> > window closes.  Is that quick enough for you?
> 
> That's fine, I just want it to reach 5.1 so it does not regress
> against 5.0.

Okay, I'll push it to 5.1-rc series for sure.


> Sorry for the slightly bad timing of my submission. I had just
> restarted
> my randconfig tests the other day and wanted to get my 60 new patches
> out as quickly as possible.

No problem! I really appreciate your sending patches and reviews.

--
Cheers,
Luca.


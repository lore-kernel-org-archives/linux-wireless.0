Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1E1C4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 15:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2D6214AE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 15:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfCMPGh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:06:37 -0400
Received: from vulcan.kevinlocke.name ([107.191.43.88]:52506 "EHLO
        vulcan.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMPGg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 11:06:36 -0400
Received: from kevinolos (unknown [71.15.201.20])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id A3AABDC5903;
        Wed, 13 Mar 2019 15:06:35 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id 24FDA130040B; Wed, 13 Mar 2019 09:06:34 -0600 (MDT)
Date:   Wed, 13 Mar 2019 09:06:34 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc:     linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [linuxwifi] [RFC] iwlwifi: enable TX AMPDU for some iwldvm
Message-ID: <20190313150634.GA10043@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
References: <20190312171205.GA12792@kevinolos>
 <0f9132187a5567fa94e396ed317efbae1aa4de14.camel@intel.com>
 <1b6eaef941d3bc887a9fbedea47c2677e5511cdd.camel@intel.com>
 <20190312203101.GA19902@kevinolos>
 <58bd45ab11912eef5c809427449a31800ecdbf53.camel@intel.com>
 <20190312214445.GA20993@kevinolos>
 <cdd094bd29f1e20dc5577fcbad6a7b404e66407a.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdd094bd29f1e20dc5577fcbad6a7b404e66407a.camel@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-03-13 at 04:58 +0000, Grumbach, Emmanuel wrote:
> Just to align on expectations, I don't feel like enable A-MPDU by
> default regardless of what will come out of this. People stopped
> complaining after we disabled A-MPDU and the very very very few people
> that did need more throughput knew how to enable them with the module
> parameter. So, I don't plan to re-enable A-MPDU by default.

I understand.  I disagree that very few people would benefit from
nearly doubling TCP throughput or that the fix is known/obvious.
However, if it's not worth the risk and/or effort, or there is no
reliable way to determine which devices/configurations are unaffected,
so be it.  Resources are limited and that's totally understandable.

Let me know if there is anything else I can do to assist.

Thanks,
Kevin

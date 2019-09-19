Return-Path: <SRS0=v6pW=XO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C54C3A5A6
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 19:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E64AE20717
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Sep 2019 19:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392253AbfISTJA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Sep 2019 15:09:00 -0400
Received: from roobidoo.pudai.com ([216.14.118.130]:59188 "EHLO
        roobidoo.pudai.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S2392247AbfISTJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Sep 2019 15:09:00 -0400
X-Greylist: delayed 3640 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 15:08:59 EDT
Received: from [71.219.36.120] (port=2568 helo=[10.168.3.100])
        by roobidoo.pudai.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <tim@smallnetbuilder.com>)
        id 1iB0qp-0000FX-LW; Thu, 19 Sep 2019 13:08:19 -0500
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     tim@smallnetbuilder.com
From:   Tim Higgins <tim@smallnetbuilder.com>
Subject: Can Intel AX200 sniff UL OFDMA ?
Message-ID: <82af1531-6f53-364c-46ed-e011455e9c01@smallnetbuilder.com>
Date:   Thu, 19 Sep 2019 14:08:18 -0400
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - roobidoo.pudai.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - smallnetbuilder.com
X-Get-Message-Sender-Via: roobidoo.pudai.com: authenticated_id: tim@timhiggins.com
X-Authenticated-Sender: roobidoo.pudai.com: tim@timhiggins.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I have been using the debug hw_sniffer_params file to tune the AX200 to a specific AID. This 
works well for capturing OFDMA DL. But I have yet to capture any UL OFDMA frames, or at least I 
don't think I have.

I am looking for QoS data frames that have HE_MU PPDU format. Is this correct?
I can see plenty of HE_SU PPDU frames from STA to AP, but no HE_MU uplink.

Am I looking for the wrong thing or can the AX200 not sniff OFDMA UL?

Thanks,
Tim Higgins

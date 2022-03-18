Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF545C433FE
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Mar 2022 07:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiCRHFu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Mar 2022 03:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiCRHFt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Mar 2022 03:05:49 -0400
X-Greylist: delayed 527 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Mar 2022 00:04:28 PDT
Received: from mxout012.mail.hostpoint.ch (mxout012.mail.hostpoint.ch [IPv6:2a00:d70:0:e::312])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77722261DF4;
        Fri, 18 Mar 2022 00:04:25 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1nV6WI-0007d5-Fb;
        Fri, 18 Mar 2022 07:55:30 +0100
Received: from dynamic-145-014-211-090.glattnet.ch ([145.14.211.90] helo=[192.168.33.151])
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1nV6WI-0004PK-B1;
        Fri, 18 Mar 2022 07:55:30 +0100
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
Message-ID: <71805121-883f-6b3f-f8dd-dffd93683dc9@reto-schneider.ch>
Date:   Fri, 18 Mar 2022 07:55:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/2] rtl8xxxu: Fill up more TX information
Content-Language: en-US
To:     Chris Chiu <chris.chiu@canonical.com>, kvalo@kernel.org,
        Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318024216.42204-1-chris.chiu@canonical.com>
From:   Reto Schneider <code@reto-schneider.ch>
In-Reply-To: <20220318024216.42204-1-chris.chiu@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

On 18.03.22 03:42, Chris Chiu wrote:
> The antenna information is missing in rtl8xxxu and txrate is NULL
> in 8188cu and 8192cu. Fill up the missing information for iw
> commands.

I tested older versions of this and it worked well. Will give this set a 
try during next week.

Kind regards,
Reto

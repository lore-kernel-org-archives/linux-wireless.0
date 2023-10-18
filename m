Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07239CDB474
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Oct 2023 00:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjJRAN2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Oct 2023 20:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJRAN1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2023 20:13:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7345D9F
        for <linux-wireless@vger.kernel.org>; Tue, 17 Oct 2023 17:13:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FD0C433C8;
        Wed, 18 Oct 2023 00:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697588004;
        bh=7EKETaIPTlMpyZz8yAKNjEOQs7PtK6fEALBLTW36zMI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M6iicX35CWLEf1hKmTmCL7aL7CZdkLc8oEMHSg3ABONrZlGwUeMisUvxeKYcSO8j7
         Tljs8Qfr7bjE7H04pshLp2MSYRa048MKGrlIJ1IuYfT3453EwR9PmhVfSH3s4/TRV9
         nJwJ8ZEmFEClWI5/eJ2gRwSTDO0cw+ROwhl35W1vkVMOwAi13O5wf8fybfjPpucWxo
         tHNs7rnQ2bLWAV8G2OFn7JLZNuChDR8pxwqkT/WYQT2cEpKl8f/dqAqkA+xWB+SR8c
         AkNLd5hSppqZt7FmkpDYkuX5h7yB1vZWVWlyuyBXvWL5ZCrgA+IcIjUe9TqaJXK95V
         HxBs7tzj2kF0A==
Date:   Tue, 17 Oct 2023 17:13:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2023-10-16
Message-ID: <20231017171324.6c7c2986@kernel.org>
In-Reply-To: <20231016143822.880D8C433C8@smtp.kernel.org>
References: <20231016143822.880D8C433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 16 Oct 2023 14:38:22 +0000 (UTC) Kalle Valo wrote:
> wireless-next patches for v6.7
> 
> The second pull request for v6.7, with only driver changes this time.
> We have now support for mt7925 PCIe and USB variants, few new features
> and of course some fixes.
> 
> Major changes:
> 
> mt76
> 
> * mt7925 support
> 
> ath12k
> 
> * read board data variant name from SMBIOS
> 
> wfx
> 
> * Remain-On-Channel (ROC) support

And due to our slowness it's almost Wednesday, anyway.. sorry about
that!

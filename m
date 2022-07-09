Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A4DCCA47C
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Jul 2022 16:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiGIQfi convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Jul 2022 12:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGIQfh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jul 2022 12:35:37 -0400
Received: from relay5.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE67EC4A
        for <linux-wireless@vger.kernel.org>; Sat,  9 Jul 2022 09:35:35 -0700 (PDT)
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id 44ACA524;
        Sat,  9 Jul 2022 16:35:34 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 75FAD20012;
        Sat,  9 Jul 2022 16:35:28 +0000 (UTC)
Message-ID: <63932b98f5c1e1ec08b9fd494da8309433abe0ce.camel@perches.com>
Subject: Re: [PATCH] wifi: api: fix repeated words in comments
From:   Joe Perches <joe@perches.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>, gregory.greenman@intel.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, keescook@chromium.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 09 Jul 2022 09:35:27 -0700
In-Reply-To: <20220709140347.52290-1-yuanjilin@cdjrlc.com>
References: <20220709140347.52290-1-yuanjilin@cdjrlc.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 75FAD20012
X-Stat-Signature: bm7t4qij4hy8tuowjnt6cbgno8341c3u
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19T01MhBdUzipsRZWbxmypFWemYZst7sXc=
X-HE-Tag: 1657384528-867336
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2022-07-09 at 22:03 +0800, Jilin Yuan wrote:
>  Delete the redundant word 'the'.
>  Delete the redundant word 'to'.
>  Delete the redundant word 'be'.
[]
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
[]
> @@ -575,7 +575,7 @@ struct iwl_sar_offset_mapping_cmd {
>   *      regardless of whether its temerature has been changed.
>   * @bf_enable_beacon_filter: 1, beacon filtering is enabled; 0, disabled.
>   * @bf_debug_flag: beacon filtering debug configuration
> - * @bf_escape_timer: Send beacons to to driver if no beacons were passed
> + * @bf_escape_timer: Send beacons to driver if no beacons were passed

to the


Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03681C433EF
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Apr 2022 06:40:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245757AbiDAGm2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Apr 2022 02:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343606AbiDAGmA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Apr 2022 02:42:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE339FEA
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2022 23:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24BB6B82273
        for <linux-wireless@vger.kernel.org>; Fri,  1 Apr 2022 06:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057C7C34110;
        Fri,  1 Apr 2022 06:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648795120;
        bh=H+IA/BpNadDS+C7iLuR4zKbyhEp2uGoxPfknbcvWpig=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Y1kAjk8d9ry+c5ms0d58/4vsxKgxobmtJTs9WJcE9BJdyAgjAVXZPCodFY2e/a6VN
         9ijEjLkmzsp1bJuW+pF90iOY5ywsBoB5njHX/U6x6QUq3YL3z/M+Yg1HGd2Gf5p6w2
         hfAbtOkeZrTUegeTGw3WQBxmM3caOdR8TeES+vg6Ob0YB1E8/ccGg5PlwbiQOjGMPB
         fhakg7EQ9sXgfUjv9ZdBwrxlba+GcNX9MYUhQi/jOkyQYTScUcQuwCzjCKfR6F+hSn
         6k2G7sekFl7FACYwNaQUcTJCMiK49XV1ixYWzJzE+8E0fQPtO0yvcJu5/LdzgyGr7E
         gq2O6lSnJmNtg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] MAINTAINERS: claim include/uapi/linux/wireless.h
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220328114029.526fbb42784d.If7c79b4ca827dfe82a545689f2d31fcedabd8387@changeid>
References: <20220328114029.526fbb42784d.If7c79b4ca827dfe82a545689f2d31fcedabd8387@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164879511773.20606.6214879248988291030.kvalo@kernel.org>
Date:   Fri,  1 Apr 2022 06:38:39 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> As much as I don't really want to maintain this legacy
> cruft that we started replacing 15+ years ago, for now
> it still falls on me to take care of it. Add a missing
> file to the list.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Patch applied to wireless.git, thanks.

598be865ee00 MAINTAINERS: claim include/uapi/linux/wireless.h

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220328114029.526fbb42784d.If7c79b4ca827dfe82a545689f2d31fcedabd8387@changeid/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


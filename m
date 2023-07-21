Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C157C04FDF
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Jul 2023 11:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjGULIv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232109AbjGULIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2023 07:08:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9DD171A;
        Fri, 21 Jul 2023 04:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF37C619D9;
        Fri, 21 Jul 2023 11:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE7FC433C8;
        Fri, 21 Jul 2023 11:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689937519;
        bh=K7zqp+s4CDeGyhNHIFPhw6m+qj8ULlENlAuVa/pcIzM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jj89ih0lGg7+izzBkhBsIasVUqFVHKkGe/DwXNZ3TtLvhSx57ZMc9NHGaY0Y7Z3XS
         m8ByqI62K/KJwynF5xUTAic6covFlxMmgFkgIvoJYGdXFCTAUesg0CGau/8coUEq8Y
         GEs2N/QLfsCRbAdbNem3+yy9APOEpQDTCm+1Zhj0ZAJi4yx6pkqW/aQxTz8vDpufNU
         KloxeQC0rFRVml2QJ8ofRWMI4tmyNSbdRusdlcWcbZQC+MeLnxDEWYR9IEscEhPLdl
         rAk2sO0eVrZ8I1+3npeu41oO4BEQ9qgAKzcxwZ0H+/KxColT/dISsWeonWpLfFpBcf
         oR3NTSZWHIuNw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wcn36xx: remove space before ')'
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <f2d9a75e98698b245e5126eb425944a1@208suo.com>
References: <f2d9a75e98698b245e5126eb425944a1@208suo.com>
To:     hanyu001@208suo.com
Cc:     linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <168993751601.2026970.14080569101846538355.kvalo@kernel.org>
Date:   Fri, 21 Jul 2023 11:05:17 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

hanyu001@208suo.com wrote:

> Fixes checkpatch.pl error:
> 
> ./drivers/net/wireless/ath/wcn36xx/dxe.c:470: ERROR: space prohibited 
> before that close parenthesis ')'
> ./drivers/net/wireless/ath/wcn36xx/dxe.c:509: ERROR: space prohibited 
> before that close parenthesis ')'
> 
> Signed-off-by: maqimei <2433033762@qq.com>

ERROR: Missing Signed-off-by: hanyu001@208suo.com

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/f2d9a75e98698b245e5126eb425944a1@208suo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


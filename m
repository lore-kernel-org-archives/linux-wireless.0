Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D711C7EE22
	for <linux-wireless@archiver.kernel.org>; Tue,  9 May 2023 05:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjEIFri (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 May 2023 01:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjEIFrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2023 01:47:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AD18A73
        for <linux-wireless@vger.kernel.org>; Mon,  8 May 2023 22:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6923D64437
        for <linux-wireless@vger.kernel.org>; Tue,  9 May 2023 05:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79FFC433D2;
        Tue,  9 May 2023 05:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683611255;
        bh=zOcgAcC8AXKTciPL55taKoUt6vrpDkRxqlwfoOtaK3k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=sgxG9HgdTYvWKii3GemqMjw9oHR1RfP+2IuHj2/FWcBNgEhZ9OALf+w84W0H0PCts
         fZy3P1faiVc2zXLfkQJuU7eDX36XtQdGg3wVTt++FyG0elAfzAvk9wUhtIn/FTNxjw
         crsfojO31HjvEutBQSueC4Mp5NjgCpNq/VyMA61kXQ/vCo6rLhriuAh3oiP4VmwSOn
         wS9kziBMovG+8582ujpRUGZqJEL4BcfJx3LEbGyl28YIS9/MA4L0Rj6+cDaLfMiqcG
         UavNP4rx6CAQcwj/hTf02P23hxahLgxc9GXuHjtByjLx0PjIfa/Sjo6lUkMDmxBVl/
         uVHuA5xd7T/Ww==
From:   Kalle Valo <kvalo@kernel.org>
To:     <Amisha.Patel@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Ajay.Kathat@microchip.com>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH] wifi: wilc1000: Increase ASSOC response buffer
References: <20230508161848.3509-1-amisha.patel@microchip.com>
Date:   Tue, 09 May 2023 08:47:31 +0300
In-Reply-To: <20230508161848.3509-1-amisha.patel@microchip.com> (Amisha
        Patel's message of "Mon, 8 May 2023 16:19:36 +0000")
Message-ID: <87a5yenjik.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Amisha.Patel@microchip.com> writes:

> In recent access points, information element is longer as they include
> additional data which exceeds 256 bytes. To accommodate longer
> association response, increase the ASSOC response buffer.
>
> Signed-off-by: Amisha <amisha.patel@microchip.com>

From field is missing your full name and s-o-b is missing your last
name. Please see the wiki link below for more information.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

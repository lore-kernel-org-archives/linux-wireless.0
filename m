Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2322BC25B46
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Oct 2023 17:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjJWRcW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Oct 2023 13:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjJWRcH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2023 13:32:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBFE173D
        for <linux-wireless@vger.kernel.org>; Mon, 23 Oct 2023 10:31:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB866C433C7;
        Mon, 23 Oct 2023 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698082301;
        bh=AS/dod8+cnjVKlcwc40UEYWf8wIGOdpnG6jklT0tvgg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JfbnKiXRr2Gq9WGkN6Juw7aQGgyEhYLu/+juuJgz0sW8m5Uobcpiio+FaVvEWo0xT
         nWlXZMrQUnVt4hX0XHyFrvqOLVyLmWDNuNifE7PjTLmtsSAR3OuAi1/SPj+IxYJs40
         xQ+kUhzzHQwygMVoSeV7GHyDFt+mEJHvrLLqD73nHweN3iTyaZLgPoBrRWYBbW6uM+
         nSr3mw7jqbqZ3olz24xwgLDdOCJj3dDx12BM295L9gGC6SnTujx/pCA2chvtsQHh5T
         bmNAoXb9hq2zt6rzBl027F+AjTNETGiEkiJCSmP53BH2GeD/9fC0AZ4EQV45jCq5+P
         JgrJNimwqxI9w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: MAINTAINERS: wifi: rt2x00: drop Helmut Schaa
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20231019202651.518136-1-stf_xl@wp.pl>
References: <20231019202651.518136-1-stf_xl@wp.pl>
To:     stf_xl@wp.pl
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169808229891.695306.9117620254859803308.kvalo@kernel.org>
Date:   Mon, 23 Oct 2023 17:31:40 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

stf_xl@wp.pl wrote:

> From: Stanislaw Gruszka <stf_xl@wp.pl>
> 
> Helmut hasn't been responding to rt2x00 related emails since 2016,
> remove him from rt2x00 mainterner list.
> 
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Patch applied to wireless-next.git, thanks.

0057680ec79a MAINTAINERS: wifi: rt2x00: drop Helmut Schaa

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20231019202651.518136-1-stf_xl@wp.pl/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39602C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Oct 2022 05:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJLFnB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Oct 2022 01:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJLFnA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2022 01:43:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D0680F6B
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2022 22:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38E3061324
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2022 05:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4812C433C1;
        Wed, 12 Oct 2022 05:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665553378;
        bh=UD98M449mjm3XrhO6K5pfGmwoVOkbmcwneMWsKdWneg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IajkvWz6wLode6De8UYaVNcgA5dI0OPPVF2TWlKqLv51G90GHgI6k17f6C5EATBEW
         uOZK2H8fAxkzdIr6xcirWsPx+g3idn3sMvByl7qaHJNOV2n0ddDVpKVg//1K5jm3I+
         tUNWyuiaS+iKQ6tkJx5+6LI89SzIvaL9GiI9hY/QS0oEtINd1R/IzAx+Yq4sXj2vlV
         5wxPKYS9yzRciYdjCp9Ue0ff8o1IVWNLgMYqz2wPTuN44D0IE6yXgvdWXvaIBgHG/B
         kD3SWqix1RDb++Nb/kZ9+2OuMlih7+hN6mvGGYGZT38KFj0B2N3AqTf1b44A+BD2kS
         mvNQAHwLWFGOw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, daniel@makrotopia.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 0/3] wifi: mt76: introduce WED TX support for mt7986 SoC
References: <cover.1664356281.git.lorenzo@kernel.org>
Date:   Wed, 12 Oct 2022 08:42:51 +0300
In-Reply-To: <cover.1664356281.git.lorenzo@kernel.org> (Lorenzo Bianconi's
        message of "Wed, 28 Sep 2022 11:19:40 +0200")
Message-ID: <87r0zd4mxw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Enable WED TX support for mt7915 and mt7986-wmac drivers running on MT7986 SoC.

What's WED TX?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

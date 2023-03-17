Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3FBC74A5B
	for <linux-wireless@archiver.kernel.org>; Fri, 17 Mar 2023 05:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjCQFWc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 Mar 2023 01:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCQFWb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2023 01:22:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818CB6BC01
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2023 22:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1420862193
        for <linux-wireless@vger.kernel.org>; Fri, 17 Mar 2023 05:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54EDC433D2;
        Fri, 17 Mar 2023 05:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679030549;
        bh=IZdTNHq7aoniAOmfsZY0Xl3GdbihMYv3TVth2Fur1KY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=puSq85yT2jPVe7KooWiCVoorSvQMhMU8C5n0Vkufn1ZjKxs4LZTntFF0M2yNHfZr7
         1IHinxHQd3HDT28PM9MBmRruSpCNz5E7OJI6CiExGlVLW34HcSp0Gm8an2XTPiXvZ2
         0p9Sh9YaOZJwo7vcaD/W4XhDzT0OUXyJrr5XjF2bWiDZBELDJs1L0vl0yuJNzxCyb5
         edc7r3fsSH0QcEa8SrJ0bKjCmYc9INA992QQdoaupioZVVBbMT0oAbie4hTvhLM4wz
         VxAscL14b0C5LDYqlokLqf/aSmzDrsOpSjPQOah1pySgieTKT3+a6bIRo3H2At5vpT
         w74W9jkXOuWiQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Aditya Kumar Singh <quic_adisi@quicinc.com>
Cc:     <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 9/9] wifi: mac80211: use proper API to fetch 6 GHz channel
References: <20230315132904.31779-1-quic_adisi@quicinc.com>
        <20230315132904.31779-10-quic_adisi@quicinc.com>
Date:   Fri, 17 Mar 2023 07:22:25 +0200
In-Reply-To: <20230315132904.31779-10-quic_adisi@quicinc.com> (Aditya Kumar
        Singh's message of "Wed, 15 Mar 2023 18:59:04 +0530")
Message-ID: <875yb0vtny.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aditya Kumar Singh <quic_adisi@quicinc.com> writes:

> Commit "wifi: mac80211: add support for 6 GHz channels and regulatory" adds
> different channel pools for different power modes for 6 GHz channels.

As that patch is not applied yet I would do s/Commit/Patch/, but no need
to resend just because of this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

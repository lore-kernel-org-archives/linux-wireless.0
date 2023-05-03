Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68393C77B78
	for <linux-wireless@archiver.kernel.org>; Wed,  3 May 2023 06:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjECGG6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 May 2023 02:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjECGG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2023 02:06:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8362680
        for <linux-wireless@vger.kernel.org>; Tue,  2 May 2023 23:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 783A160F59
        for <linux-wireless@vger.kernel.org>; Wed,  3 May 2023 06:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBF1C433D2;
        Wed,  3 May 2023 06:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683094010;
        bh=14vWyACdAlpviMqo/JMD3zkhlbzDVQOA0xylV/06V/A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oDN69PnXR/zFGwTsSMhVvEpeX7bMpAx1wqiclWJLenAs+ytVml3IQ6zY5jd8Rl5SM
         +q9YCHAV44qRhn+DdDsnmM8YLAJQC72iZhOqJdHDlXm1/AAb9Har5Cfja/yxCzYl9k
         o0hGlopDK7YIKZhsjVRZA2Bd4tdoL7h5lRZx2gsDRpnL4UTrlgyN/4C4A+T4Uz4uPi
         k3Mh8KeXaT+Yq4tkNzg0ZS4Z7LQLvEH9LUO+fSGs7zE2MQB9Q/yu/J82VdJI+MS0ns
         mxL6VqwPVPu/rMHTKWgbU2OFWUWRDT9AgxGXOuLGtPOszki9ilPiBta4yP0Qtvq1y6
         SVoOuQXBtN5vQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-next] wifi: mt76: mt76x02: remove WEP support
References: <d560f1a16c9024b6e4029bd0baf53384f4552f5a.1683020788.git.lorenzo@kernel.org>
Date:   Wed, 03 May 2023 09:06:46 +0300
In-Reply-To: <d560f1a16c9024b6e4029bd0baf53384f4552f5a.1683020788.git.lorenzo@kernel.org>
        (Lorenzo Bianconi's message of "Tue, 2 May 2023 11:49:05 +0200")
Message-ID: <871qjyosnd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Get rid of WEP support in mt76x02_set_key routine since it is not longer
> supported upstream.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

You marked this for wireless-next so should I take this directly?

Does this fix something or is just cleanup? It would be good to mention
that in the commit log.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

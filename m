Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48730C0015E
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jul 2023 15:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjGYPDm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jul 2023 11:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbjGYPD2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2023 11:03:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E005E423F
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 08:02:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89F9B6178E
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2023 15:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5358C433C7;
        Tue, 25 Jul 2023 15:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690297342;
        bh=NyP6PlDxVmNKc7QuIQAt2DqX8bLd6UShTJuw9bEoaD4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Fb0Fw7L3nQmk6NXKrx+LN4SAwRXQWZTvo7AUvsQc4iFpgUomzjaZmgpOM8v2HNzTF
         j8NlZzL9dY35YsWHgdpbiARkNUVq5XnHWf0LGMC93Q16i/69fQCm/aaBcFfceK01wZ
         c+IVzpypeZ4YGus3ExzQUscCRxzE3rSi20dZ5RUIj44aMMdDBBew5Mtr3c9q+oyzRK
         fryXP4JfXA4ELaFC9S3f4wxC8Rzx0zZ6/MpEzppyGO/jkT3jPPOfsZK2J6EDzIJxMj
         qrw7PDtPhAFJcOqAYkpKy1qhblAMF7A03oku6Vcq01Png6k1OFnJv97scJOuyowL5t
         zvx5hAyooJb9Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: wilc1000: change firmware path from 'atmel' to
 'microchip/wilc'
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230707194025.47085-1-ajay.kathat@microchip.com>
References: <20230707194025.47085-1-ajay.kathat@microchip.com>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Claudiu.Beznea@microchip.com>,
        <Sripad.Balwadgi@microchip.com>, <Ajay.Kathat@microchip.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.11.2
Message-ID: <169029733980.3309254.13764649412478833521.kvalo@kernel.org>
Date:   Tue, 25 Jul 2023 15:02:21 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Ajay.Kathat@microchip.com> wrote:

> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> To inline 'linux-firmware' path with driver, the firmware path is changed
> from 'atmel' to 'microchip/wilc'. The path change will be submitted to
> 'linux-firmware' repo.
> For backward compatibility, when the updated kernel and older
> linux-firmware that has firmware at 'atmel/' path are used, add a fallback
> method to read firmware from 'atmel' path.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>

Like discussed in the other thread, I'm dropping this.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230707194025.47085-1-ajay.kathat@microchip.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


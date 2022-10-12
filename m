Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E13C4332F
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Oct 2022 14:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJLOej (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Oct 2022 10:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJLOeg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2022 10:34:36 -0400
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F9A2BA;
        Wed, 12 Oct 2022 07:34:35 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id bk15so26497355wrb.13;
        Wed, 12 Oct 2022 07:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tor9Al5zKFy4H384gqWBoxXv/hFxksivsNXjuDpRGaw=;
        b=LsbsHdymJCHIUtf60MxaFEX1GSTr4ush2srZ/CG9mouefD1Nf+tTZQTX0aNsy7FeqY
         XtqhwA1xqSGsW275W/C8v8Tg8SwMa1oBvz4sspcAD06ec/HcbHeUfCLvDBe7zyGeI8Mf
         9oRWM2jYZf6FuLuld2k1khEj0sPdCvZvHoVOOo1DWfyGSe/9Sd+tjCKzTPpgQlep1weH
         sxVGzpbSs6v+9s9xfxowxwJ3XfRjgBm7RAPj1nOw4J4V06d+mREK8Q3EVaNjmBBs1Sw/
         uKRU62EDduTOcrJYHvd7dF9jfMUMSe9NVL2ImHiS7qsG7bRHQ11JgpruoTYQYHsbrsv3
         Ebrg==
X-Gm-Message-State: ACrzQf0zueQ8ADethoUhXArzYKEuhbkfnuy/lb98YZKfjJ1A1UmfzBvP
        raWjbeWXzEvoRLohATwJEiW9EYUJ+Os8WiR5ZKw=
X-Google-Smtp-Source: AMsMyM5q7nOEeGxpb90r8BpgH/goefH7ZF9xFGoX3X6IYwsHHjbU0d+LCLtmUkdkv+x2O6are+Nhuj0nkQQUrEbM4n4=
X-Received: by 2002:a05:6000:801:b0:230:45ad:fba6 with SMTP id
 bt1-20020a056000080100b0023045adfba6mr11248444wrb.514.1665585274073; Wed, 12
 Oct 2022 07:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <20221012142733.32420-1-quic_youghand@quicinc.com>
In-Reply-To: <20221012142733.32420-1-quic_youghand@quicinc.com>
From:   Adrian Chadd <adrian@freebsd.org>
Date:   Wed, 12 Oct 2022 07:34:22 -0700
Message-ID: <CAJ-VmomqwxD4wnuz3GJDaXUV71s_4aexY+3xYcDhXSKgo-9Zng@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: ath10k: Delay the unmapping of the buffer
To:     Youghandhar Chintala <quic_youghand@quicinc.com>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surely this should be a firmware fix/patch?



-adrian

Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6217C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADE5020883
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfDHMsd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:48:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53404 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbfDHMsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:48:33 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1hDThQ-0000TR-97
        for linux-wireless@vger.kernel.org; Mon, 08 Apr 2019 12:48:32 +0000
Received: by mail-it1-f197.google.com with SMTP id l202so12504015ita.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2019 05:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=VaxxEll9ULaaE8ut29yUXAJ9vAKKyojtJHWcUYZTqrQ=;
        b=QjKS6tH0kwSpBRfOklV113N4RQ5BZKiT0MTnolMN2pcpORZOV78aL6QY7pMZ6gBsHv
         oFn/JPEvmbgkeBAhNYdymFT8S6N3j0MfQg9XXpYWe4ruN0WYC0WyJ2UEOA0J/UyBz0EX
         I20LRPYeI+SeMQ9QHHCeMpcyLaS7VY76qh2zsyR6XpyINOA54vvDLX/3YSojzVkpFViU
         wVuzHfDW3S5F/ige/X6tKw9+rBS7iNehdZgtgIxLZq20J7zm94/n91bcNL8a9D6y4CCg
         e41W096+YhsFOCoP3MfHMDy6739RLrk4mqNrYLp3RefM3lfRYnd0WA0oZ2bTjhhJWDte
         6iiw==
X-Gm-Message-State: APjAAAWun8VSWn4R6MElq68oGQy/aN9yVjRLmCr84SeViVUeJkhs/35y
        mpgMhFMLlq2kaXCDZP4eLULK2BWzN/40sUL6fuppbK1mcT/w7wbikU/Z9nzFnIpez6cPkXWQ1zp
        lsujDf696sWSc1BZyauJOfaq2nqVPPz7vI4iWXHl+fpyf
X-Received: by 2002:a6b:3ec3:: with SMTP id l186mr18201041ioa.255.1554727711119;
        Mon, 08 Apr 2019 05:48:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxR0Fd+tVM+egqP46DCHP3QUi1A5e9nglrgMTdK/DqYHfWZTyM+tzbYrzpNdReISwJEuMIizA==
X-Received: by 2002:a6b:3ec3:: with SMTP id l186mr18201030ioa.255.1554727710819;
        Mon, 08 Apr 2019 05:48:30 -0700 (PDT)
Received: from localhost ([2605:a601:ac2:fb20:3d51:1338:4e8e:1eab])
        by smtp.gmail.com with ESMTPSA id z13sm11315694ioj.21.2019.04.08.05.48.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 05:48:29 -0700 (PDT)
Date:   Mon, 8 Apr 2019 07:48:29 -0500
From:   "seth.forshee" <seth.forshee@canonical.com>
To:     "junping.xu@jaguarwave.com" <junping.xu@jaguarwave.com>
Cc:     wireless-regdb <wireless-regdb@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-regdb: Please update regulatory rules for Japan (JP) on
 60GHz
Message-ID: <20190408124829.GD15126@ubuntu-xps13>
References: <2019040118074276659215@jaguarwave.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2019040118074276659215@jaguarwave.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 01, 2019 at 06:07:44PM +0800, junping.xu@jaguarwave.com wrote:
> Hi Forsheee,
>       The 60GHz band defined for Japan was between 59-66GHz, but is has been Updated to support 57-66Ghz about 2 years ago。
> However, the latest wireless-regdb still containning the original regulatory information  as below. Please help to check the infomation 
> and update the regulatory.bin.
> 
> db.txt:
> ......
> country JP: DFS-JP
> (2402 - 2482 @ 40), (20)
> (2474 - 2494 @ 20), (20), NO-OFDM
> (4910 - 4990 @ 40), (23)
> (5030 - 5090 @ 40), (23)
> (5170 - 5250 @ 80), (20), AUTO-BW
> (5250 - 5330 @ 80), (20), DFS, AUTO-BW
> (5490 - 5710 @ 160), (23), DFS
> # 60 GHz band channels 2-4 at 10mW,
> # ref: http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.pdf

The only change which is required to change:

> (59000 - 66000 @ 2160), (10 mW)

to:

 (57000 - 66000 @ 2160), (10 mW)

Is that right? Can you provide a link to the documentation which
supports this change? The current link above this rule appears to be
broken.

Thanks,
Seth

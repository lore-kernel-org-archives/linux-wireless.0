Return-Path: <SRS0=ZZIE=OB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA42C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Nov 2018 01:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A7B0206BA
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Nov 2018 01:11:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A7B0206BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388786AbeKVLsT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Nov 2018 06:48:19 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:35672 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388763AbeKVLsT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Nov 2018 06:48:19 -0500
Received: by mail-pl1-f182.google.com with SMTP id v1-v6so7911495plo.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2018 17:11:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bjrl5lh1tFmDvFCAfA8F77fN/5LZxRoyCVN1A/CJlOY=;
        b=ih6u8buEFJm9nKsyPJT+d44euD+W9S/WDyLnztyWJ31fQj4paPAfZg9tqYB/bJSoFK
         e0tId7QUXoBN3mR2ZM23s9fCuAzHKWQJOwqOJJ1kjAxpypx2g/Q+8Ys7gFCajsHv2EPq
         KvoXd7aCzlYXQeI8I9rZQQLdRLBKLQjYRb3nhezDxuCH1ysrCHdKvu5KQuY0mAAUtSSv
         OQv/aNPnZdJ1MXmnEtSmaDS0xZfRxYdCAF9lnZJTzxUgf3RUIR0M6GrYoBfqd+t3kqp3
         Ha7a3Yt92XBE+BfkKS5zgGozSkXMlQzsONgg+MDAF1WtY3anEeQv+sHXR6Ks+Kb5Yenh
         5RXw==
X-Gm-Message-State: AA+aEWZ7qjSAPUgo9Snd9X7nPR4ZDSNYXsDXUXHkrA/0dXU3jdY0nx1N
        wglFhxBLsYmtwWqECKhcWWt5ugqT
X-Google-Smtp-Source: AFSGD/VYtC/AfT+IbOWFjFGfoVWJSdcyfZqX9/hrWFSZNuswr4J8FZWpnMjLP92poAk8+Iv7q6Soyg==
X-Received: by 2002:a63:ef0b:: with SMTP id u11-v6mr8056593pgh.283.1542849085390;
        Wed, 21 Nov 2018 17:11:25 -0800 (PST)
Received: from garbanzo.do-not-panic.com (c-73-71-40-85.hsd1.ca.comcast.net. [73.71.40.85])
        by smtp.gmail.com with ESMTPSA id v70sm11695206pfa.152.2018.11.21.17.11.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 17:11:23 -0800 (PST)
Received: by garbanzo.do-not-panic.com (sSMTP sendmail emulation); Wed, 21 Nov 2018 17:11:20 -0800
Date:   Wed, 21 Nov 2018 17:11:20 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: Re: [PATCH] crda: add URLs to README
Message-ID: <20181122011120.GF4922@garbanzo.do-not-panic.com>
References: <20181109162323.25024-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109162323.25024-1-xose.vazquez@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 05:23:23PM +0100, Xose Vazquez Perez wrote:
> Cc: Luis R. Rodriguez <mcgrof@kernel.org>
> Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
> Cc: REGDB ML <wireless-regdb@lists.infradead.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Applied and pushed, thanks. Please note that as of v4.15 CRDA is no
longer needed. I've updated the README to reflect this.

  Luis

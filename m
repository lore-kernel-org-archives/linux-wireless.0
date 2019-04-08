Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FD6C10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99BF4214C6
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfDHMmF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:42:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53156 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfDHMmF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:42:05 -0400
Received: from mail-yb1-f200.google.com ([209.85.219.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1hDTb8-0008Mp-LD
        for linux-wireless@vger.kernel.org; Mon, 08 Apr 2019 12:42:02 +0000
Received: by mail-yb1-f200.google.com with SMTP id k76so4917464ybk.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2019 05:42:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q+UBWvNK9F3+Y5i3IwaIJfT37NJ/BxmyKEw1tg/Eobw=;
        b=JWng+mDNSVE08AsMliTt1/S5U3Zrd0++t6PkwaJpPRqNRfhGVdbdqEIL/ccVEymubz
         UovXwvBPg1Vcm0Ewb53FRugCpKdlmUf/XQWnqeIjkyqFcrz7XKJFOIcSBDNh5jcxQ5rB
         uUiBRlywhKoTIN4sU9GQ4k0hd8ymDo28KeX2ssqHgMVbaHq95sHiO/NCyxYa73coYsdC
         WUhvQFMVoOrytNSOKCkWGrUOp45T652eH8zT0fFvl1EB/Lr00rd4HbgPTe+febIbekhO
         EX8DcA8P3izsndsqF6CZeekIbsGefIqTFYTvbVFeNhsF2HPGot89Tcb1bEwJMzt0badU
         Y9hQ==
X-Gm-Message-State: APjAAAWbuVQm1Xkq4azp25NcCRzJ3tOavJfodJCDc/4EcTBr7LiVAIKf
        siEmOXFZbHJr/7YgQ9hTqCKWVPcfXPkdYT9rY6VrHfd3GOKeaeLuxrrziA70kyH30bsD93TMBFb
        n3cIdzLGZcsRugxuI3DIJUIYCy6y9JM7K8tY+9PllGFlP
X-Received: by 2002:a25:14c1:: with SMTP id 184mr24934775ybu.403.1554727321525;
        Mon, 08 Apr 2019 05:42:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxkL/NUQINv1x+wtUVaajd6Q6G6inZne3TmjY7eDMCuSPDdSChvtG/Ab+LgKEUgPrSqHfn1ww==
X-Received: by 2002:a25:14c1:: with SMTP id 184mr24934748ybu.403.1554727321148;
        Mon, 08 Apr 2019 05:42:01 -0700 (PDT)
Received: from localhost ([2605:a601:ac2:fb20:3d51:1338:4e8e:1eab])
        by smtp.gmail.com with ESMTPSA id 196sm10943042ywf.69.2019.04.08.05.41.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 05:42:00 -0700 (PDT)
Date:   Mon, 8 Apr 2019 07:41:59 -0500
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Peter Oh <peter.oh@bowerswilkins.com>
Cc:     "wireless-regdb@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for South Korea
Message-ID: <20190408124159.GC15126@ubuntu-xps13>
References: <1553711659-27600-1-git-send-email-peter.oh@bowerswilkins.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553711659-27600-1-git-send-email-peter.oh@bowerswilkins.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 27, 2019 at 06:34:29PM +0000, Peter Oh wrote:
> From: Peter Oh <peter.oh@bowerswilkins.com>
> 
> Update power limit as documented in:
> https://www.rra.go.kr/FileDownSvl?file_type=LAWKR&file_parentseq=54&file_seq=27
> which revised on November 30, 2016.
> 
> Signed-off-by: Peter Oh <peter.oh@bowerswilkins.com>

I usually try to check the changes against the documents, but in this
case I haven't been able to get any English tranlation for the document
(or even view the contents it in any meaningful way). I don't suppose
you know where to find an English version of the document?

Thanks,
Seth

> ---
>  db.txt | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index 4fb1948..52c17e9 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -695,11 +695,12 @@ country KP: DFS-JP
>  	(5735 - 5815 @ 20), (30)
>  
>  country KR: DFS-JP
> -	(2402 - 2482 @ 40), (13)
> -	(5170 - 5250 @ 80), (20), AUTO-BW
> -	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
> -	(5490 - 5710 @ 160), (30), DFS
> -	(5735 - 5835 @ 80), (30)
> +	# ref: https://www.rra.go.kr/ko/reference/lawList_view.do?lw_seq=54&lw_type=3&searchCon=&lw_select=ALL&lw_model=&searchTxt=
> +	(2402 - 2482 @ 40), (23)
> +	(5170 - 5250 @ 80), (17), AUTO-BW
> +	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
> +	(5490 - 5710 @ 160), (23), DFS
> +	(5735 - 5835 @ 80), (23)
>  	# 60 GHz band channels 1-4,
>  	# ref: http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B4%EC%84%A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99
>  	(57000 - 66000 @ 2160), (43)
> -- 
> 2.7.4
> 
> 
> _______________________________________________
> wireless-regdb mailing list
> wireless-regdb@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wireless-regdb

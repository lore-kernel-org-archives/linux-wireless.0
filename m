Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34651 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbcEaMfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 08:35:53 -0400
Received: by mail-oi0-f54.google.com with SMTP id e72so21287088oib.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 05:35:52 -0700 (PDT)
Date: Tue, 31 May 2016 07:35:50 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	wil6210@qca.qualcomm.com
Subject: Re: [PATCH] wireless-regdb: Republic of Korea: Add 60GHz regulatory
 rules
Message-ID: <20160531123550.GA93568@ubuntu-hedt> (sfid-20160531_143555_940879_E78CF89C)
References: <1463822708-20053-1-git-send-email-qca_merez@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463822708-20053-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 21, 2016 at 12:25:08PM +0300, Maya Erez wrote:
> Add 60GHz regulatory rules for Korea (KR).
> Source is
> http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B4%EC%84%A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99
> 
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  db.txt | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/db.txt b/db.txt
> index da16f7c..143f915 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -664,6 +664,10 @@ country KR: DFS-JP
>  	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
>  	(5490 - 5710 @ 160), (30), DFS
>  	(5735 - 5835 @ 80), (30)
> +	# 60 GHz band channels 1-4,
> +	# ref: http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B4%EC%84%A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99
> +	(57000 - 66000 @ 2160), (57)
> +

Thanks for the patch. I wanted to double check with you that the power
limit is correct though, since it seems extremely high (an order of
magnitude higher than what we have for any other country in fact). I
can't make out much of anything from the link, and I can't even run it
through google translate since it's composed of images rather than text.

Thanks,
Seth


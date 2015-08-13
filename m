Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:33233 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbHMOcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 10:32:15 -0400
Received: by igfj19 with SMTP id j19so423083igf.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2015 07:32:14 -0700 (PDT)
Date: Thu, 13 Aug 2015 09:31:54 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: add 2.4GHz regulatory rules for Cuba (CU)
Message-ID: <20150813143154.GA121347@ubuntu-hedt> (sfid-20150813_163221_758473_C5C0F9D2)
References: <1439299795-17359-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1439299795-17359-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 11, 2015 at 03:29:55PM +0200, Xose Vazquez Perez wrote:
> Resolución 127, 2011 - Reglamento Banda 2,4 GHz.:
> http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf
> 
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: wireless-regdb@lists.infradead.org
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  db.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/db.txt b/db.txt
> index 982db34..2edbf90 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -275,6 +275,13 @@ country CR: DFS-FCC
>  	(5490 - 5730 @ 20), (24), DFS
>  	(5735 - 5835 @ 20), (30)
>  
> +# http://www.mincom.gob.cu/?q=marcoregulatorio
> +# - Redes Informáticas
> +# Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
> +country CU: DFS-FCC
> +	(2400 - 2456 @ 40), (200 mW)
> +	(2456 - 2483.5 @ 40), (200 mW)
> +

Based on the Google translation of the document you linked to, I don't
see anything which would prevent merging these rules into one rule. Am I
missing something?

Thanks,
Seth

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:50286 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbZC3ULw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:11:52 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LoNpk-0004gV-I3
	for linux-wireless@vger.kernel.org; Mon, 30 Mar 2009 20:11:48 +0000
Received: from port-87-193-186-180.static.qsc.de ([87.193.186.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 20:11:48 +0000
Received: from thomas by port-87-193-186-180.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 20:11:48 +0000
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: wireless-regdb: Update regulatory rules for Germany (DE) on 5GHz
Date: Mon, 30 Mar 2009 22:11:38 +0200
Message-ID: <gqr91q$lbo$1@ger.gmane.org> (sfid-20090330_221157_131472_6A9F708A)
References: <1238113267.29544.14.camel@blob>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <1238113267.29544.14.camel@blob>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bernhard Seibold schrieb:
> --- a/db.txt	2009-03-25 19:38:22.838975857 +0100
> +++ b/db.txt	2009-03-25 19:39:37.722248019 +0100
> @@ -165,8 +165,8 @@
>  country DE:
>  	# entries 279004 and 280006
>  	(2400 - 2483.5 @ 40), (N/A, 100 mW)
> -	# entries 303005 and 304002
> -	(5150 - 5255 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
> +	# entries 303005, 304002 and 305002
> +	(5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR, DFS
>  	# entries 308002 and 309001
>  	(5470 - 5650 @ 40), (N/A, 1000 mW), DFS
>  
> 

What about 5650-5725? Shouldn't that be added as well? At least my 
university runs an AP at 5.7GHz.


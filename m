Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34748 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbcDVNzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 09:55:38 -0400
Received: by mail-ob0-f179.google.com with SMTP id bg3so49102611obb.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2016 06:55:38 -0700 (PDT)
Date: Fri, 22 Apr 2016 08:55:29 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Anne Marcel Roorda <marcel@slowthinkers.net>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: Update regulatory rules for NL as per ETSI EN 300 440-1
Message-ID: <20160422135529.GA109717@ubuntu-hedt> (sfid-20160422_155543_477689_C220FE98)
References: <20160422123614.2B4EC2063D@density.slowthinkers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160422123614.2B4EC2063D@density.slowthinkers.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 22, 2016 at 02:36:13PM +0200, Anne Marcel Roorda wrote:
> 
> Hi,
> 
>   Below the patch to include SRD as per ETSI EN 300 440-1
> for NL.
> 
> Thanks,
> 
> - marcel
> 
> Signed-off-by: Anne Marcel Roorda <marcel@slowthinkers.net>
> 
> diff --git a/db.txt b/db.txt
> index e9ba21a..738e412 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -850,11 +850,18 @@ country NI: DFS-FCC
>  	(5490 - 5730 @ 160), (24), DFS
>  	(5735 - 5835 @ 80), (30)
>  
> +# Regulation on the use of frequency space without a license and 
> +# without notification 2015
> +#
> +# http://wetten.overheid.nl/BWBR0036378/2015-03-05
> +
>  country NL: DFS-ETSI
>  	(2402 - 2482 @ 40), (20)
>  	(5170 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
>  	(5250 - 5330 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
>  	(5490 - 5710 @ 160), (27), DFS
> +	# short range devices (ETSI EN 300 440-1)
> +	(5725 - 5875 @ 80), (25 mW)
>  	# 60 GHz band channels 1-4, ref: Etsi En 302 567
>  	(57000 - 66000 @ 2160), (40)

I'm looking at the document you reference as translated by Google, and
I'm not seeing anything there to support these changes. I can't find any
reference to ETSI 300 440-1. The section which would appear to apply
here (article 2 paragraph o) references Annex 11 for permitted frequency
bands, and this does not include the range that you're adding.

I didn't read the document in its entirety though, so I may have missed
something. If so, could you please point me to the specific section
which would permit operation in that range?

Thanks,
Seth

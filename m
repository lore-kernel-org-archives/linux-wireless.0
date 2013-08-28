Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab3H1IXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 04:23:49 -0400
Message-ID: <1377678223.13797.7.camel@jlt4.sipsolutions.net> (sfid-20130828_102357_512865_FC1C51C8)
Subject: Re: [PATCH] iw:  Print Interworking IE details in scan results.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Aug 2013 10:23:43 +0200
In-Reply-To: <1377619631-14699-1-git-send-email-greearb@candelatech.com> (sfid-20130827_180728_764261_AD0BAEF5)
References: <1377619631-14699-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130827_180728_764261_AD0BAEF5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-27 at 09:07 -0700, greearb@candelatech.com wrote:

> 	802.11u Interworking:
> 		Network Options: 0xf1
> 			Network Type: 1 (Private with Guest)
> 			Internet
> 			ASRA
> 			ESR
> 			UESA
> 		Venu Group: 2 (Business)
> 		Venu Type: 1

That should be "Venue", no?


> Signed-off-by: Ben Greear <greearb@candelatech.com>

No need really, btw, this doesn't mean anything in the iw repository - I
haven't bothered to add something (yet).

> +++ b/scan.c
> @@ -614,6 +614,69 @@ static void print_ht_capa(const uint8_t type, uint8_t len, const uint8_t *data)
>  	print_ht_mcs(data + 3);
>  }
>  
> +static const char* ntype_11u(uint8_t t) {

I'd prefer kernel style with the opening brace on the next line :)

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2912 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3GDSXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 14:23:37 -0400
Message-ID: <51D5BD9D.5020604@broadcom.com> (sfid-20130704_202340_514148_F96CDFB0)
Date: Thu, 4 Jul 2013 20:23:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 42/53] wireless-regdb: ID, Indonesia - enable 5 GHz
 and VHT80
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
 <1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1372899889-19183-43-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2013 03:04 AM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> Pursuant to:
>
> http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf,
>
> provide a 5GHz rule for Indonesian regulatory domain. QCA has
> also verified VHT80 can be enabled. Patch originally posted by
> Paul Stewart <pstew@chromium.org>, I just modified to enable 80 MHz
> bandwidth.

Hi Luis,

Is it just me or did you make a typo. Should '@ 20' be '@ 80' ?

Gr. AvS

> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> ---
>   db.txt |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/db.txt b/db.txt
> index 0ebb934..a101b1e 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -380,7 +380,9 @@ country HU: DFS-ETSI
>   	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
>
>   country ID:
> +	# ref: http://www.postel.go.id/content/ID/regulasi/standardisasi/kepdir/bwa%205,8%20ghz.pdf
>   	(2402 - 2482 @ 40), (N/A, 20)
> +	(5735 - 5815 @ 20), (N/A, 20)
>
>   country IE: DFS-ETSI
>   	(2402 - 2482 @ 40), (N/A, 20)
>



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47205 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0FRSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 14:45:12 -0400
Date: Fri, 18 Jun 2010 14:42:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Subject: Re: [RFC] wireless-regdb: Add A band in IL
Message-ID: <20100618184257.GB6282@tuxdriver.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 09:49:29AM +0300, Emmanuel Grumbach wrote:
> A band in allowed in IL, according to official document issued by the Ministry
> of Communications: http://www.moc.gov.il/sip_storage/FILES/1/1061.pdf.
> 
> 5150 - 5250 200mW e.i.r.p. OUTDOOR forbidden
> 5250 - 5350 200mW e.i.r.p. OUTDOOR forbidden DFS mandatory
> 
> 40Mhz is allowed in A band for every WiFi-Alliance certified equipment.
> 
> ***************************************************************
> Not to be merged for the moment
> ***************************************************************
> 
> CC: Michael Green <Michael.Green@atheros.com>
> CC: David Quan <David.Quan@atheros.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  db.txt |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/db.txt b/db.txt
> index e63a43e..d49c397 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -319,6 +319,8 @@ country IE:
>  
>  country IL:
>  	(2402 - 2482 @ 40), (N/A, 20)
> +	(5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
> +	(5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
>  
>  country IN:
>  	(2402 - 2482 @ 40), (N/A, 20)

Is this issue now settled?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

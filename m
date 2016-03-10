Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51779 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbcCJT64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 14:58:56 -0500
Date: Thu, 10 Mar 2016 14:58:54 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Kyle McMartin <kyle@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi -21.ucode firmware
Message-ID: <20160310195854.GD21789@merlin.infradead.org> (sfid-20160310_205859_212872_A30485E0)
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA66A24@hasmsx107.ger.corp.intel.com>
 <20160310184933.GA21789@merlin.infradead.org>
 <0BA3FCBA62E2DC44AF3030971E174FB32EA68CFE@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA68CFE@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2016 at 07:15:31PM +0000, Grumbach, Emmanuel wrote:
> > Pulled, can you follow this up and update WHENCE? I'd do it, but there's
> > a lack of consistency between Version: and some of the past commit
> > messages, so I'm not sure what the right value would be.
> > 
> 
> Ooops - sorry:
> 

no worries, gotcha.

--kyle

> e6dedba0a09221a755ae4573d70b86c804a14be2 in the same tree.
> 
> diff --git a/WHENCE b/WHENCE
> index e249c49..a9c5e98 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -897,12 +897,24 @@ Version: 25.30.13.0
>  File: iwlwifi-7265D-16.ucode
>  Version 16.242414.0
> 
> +File: iwlwifi-7265D-21.ucode
> +Version 21.302800.0
> +
> +File: iwlwifi-3168-21.ucode
> +Version 21.302800.0
> +
>  File: iwlwifi-8000C-13.ucode
>  Version: 25.30.13.0
> 
>  File: iwlwifi-8000C-16.ucode
>  Version 16.242414.0
> 
> +File: iwlwifi-8000C-21.ucode
> +Version 21.302800.0
> +
> +File: iwlwifi-8265-21.ucode
> +Version 21.302800.0
> +
>  Licence: Redistributable. See LICENCE.iwlwifi_firmware for details
> 
>  Also available from
> http://wireless.kernel.org/en/users/Drivers/iwlwifi#Firmware
> 
> 

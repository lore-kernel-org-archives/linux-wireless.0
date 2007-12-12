Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:47070 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbXLLQ6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 11:58:30 -0500
Received: by rv-out-0910.google.com with SMTP id k20so261233rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2007 08:58:29 -0800 (PST)
Message-ID: <43e72e890712120858y4141d894j6b8e71a72a36dfe4@mail.gmail.com> (sfid-20071212_165832_508058_EDE585E0)
Date: Wed, 12 Dec 2007 11:58:29 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH v2] introduce WEXT scan capabilities
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jean Tourrilhes" <jt@hpl.hp.com>, linux-wireless@vger.kernel.org,
	"David Miller" <davem@davemloft.net>
In-Reply-To: <1197473107.12484.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1197473107.12484.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 12, 2007 10:25 AM, Dan Williams <dcbw@redhat.com> wrote:
> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -541,6 +541,16 @@
>  /* Maximum size of returned data */
>  #define IW_SCAN_MAX_DATA       4096    /* In bytes */
>
> +/* Scan capability flags - in (struct iw_range *)->scan_capa */
> +#define IW_SCAN_CAPA_NONE              0x00
> +#define IW_SCAN_CAPA_ESSID             0x01
> +#define IW_SCAN_CAPA_BSSID             0x02
> +#define IW_SCAN_CAPA_CHANNEL   0x04
> +#define IW_SCAN_CAPA_MODE              0x08
> +#define IW_SCAN_CAPA_RATE              0x10
> +#define IW_SCAN_CAPA_TYPE              0x20
> +#define IW_SCAN_CAPA_TIME              0x40
> +

Oh well... Would you mind putting this on enum and kerneldoc'ing them?
I'm not sure what some of these would imply capabilities for.

  Luis

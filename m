Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:14711 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXLLOl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 09:41:26 -0500
Received: by nz-out-0506.google.com with SMTP id s18so137573nze.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2007 06:41:25 -0800 (PST)
Message-ID: <b25c3fa70712120641l1fcf4447u2501cc8539396cf3@mail.gmail.com> (sfid-20071212_144132_441475_5D005E16)
Date: Wed, 12 Dec 2007 23:41:24 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] [net/wireless/iwlwifi] : iwlwifi 3945 Fix raceconditional panic.
Cc: "Zhu Yi" <yi.zhu@intel.com>, ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20071212034325.4a022320.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <00e501c831ab$2e78daa0$9c94fea9@jason>
	 <1196298656.7614.77.camel@debian.sh.intel.com>
	 <016401c83229$3302d250$9c94fea9@jason>
	 <20071212034325.4a022320.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/12/12, Andrew Morton <akpm@linux-foundation.org>:
>
> Did drivers/net/wireless/iwlwifi/iwl4965-base.c get fixed in a simlar
> fashion?
>

Hi Andrew,
Both of them was applied to mainline.

commit 3ae6a054553ee8b7f74bf7de8904022b26705778
Author: Joonwoo Park <joonwpark81@gmail.com>
Date:   Thu Nov 29 10:43:16 2007 +0900

    iwlwifi 4965 Fix race conditional panic.

    Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit e47eb6ad41e8fc4c2696665512b70d1fd4cf3f22
Author: Joonwoo Park <joonwpark81@gmail.com>
Date:   Thu Nov 29 10:42:49 2007 +0900

    iwlwifi 3945 Fix race conditional panic.

    Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks,
Joonwoo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3876 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbYDXM7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 08:59:35 -0400
Date: Thu, 24 Apr 2008 08:16:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Roel Kluin <12o3l@tiscali.nl>, linux-wireless@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: rndis_wlan: modparam_workaround_interval is
	never below 0.
Message-ID: <20080424121613.GA3879@tuxdriver.com> (sfid-20080424_150008_988678_22114EB3)
References: <480F97B5.9030009@tiscali.nl> <1209027451.3357.49.camel@johannes.berg> <20080424122628.zioaht24o4ko4ww8@naisho.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080424122628.zioaht24o4ko4ww8@naisho.dyndns.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 24, 2008 at 12:26:28PM +0300, Jussi Kivilinna wrote:
> Quoting Johannes Berg <johannes@sipsolutions.net>:
>
>>
>> Eh, why not make the modparam unsigned and default to 500?
>>
>> johannes
>>
>
> Now that I stop and think about it, that would be better option. The 
> modparam already has default value of 500.
>
> Reason why workaround modparam is signed, is that value -1 did have some 
> functionality in some early version. That then changed and 
> priv->param_workaround_interval changed to unsigned and forgot about 
> modparam.

I merged the patch, so if you want that behavior we need a new patch.

John
-- 
John W. Linville
linville@tuxdriver.com

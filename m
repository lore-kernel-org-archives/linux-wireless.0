Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:1962 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYIZXN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 19:13:27 -0400
Message-ID: <48DD6A65.1060209@errno.com> (sfid-20080927_011332_648367_EEE456B8)
Date: Fri, 26 Sep 2008 16:04:05 -0700
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@venema.h4ckr.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Release of Atheros 802.11abg HAL under the ISC
References: <20080926215701.GC5972@tesla> <48DD687E.5060703@gmail.com> <20080926230149.GE5972@tesla>
In-Reply-To: <20080926230149.GE5972@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, Sep 26, 2008 at 03:55:58PM -0700, Maxim Levitsky wrote:
>   
>> If I understand this correctly, madwifi is no longer a non-free driver?
>>     
>
> MadWifi is based on a proprietary HAL which is slightly different
> than this one, so no, its still non-free. The "free" drivers where
> I think focus should be put in is ath5k and ath9k as they are now both
> merged as part of the Linux kernel.
>   

The hal is not proprietary; Atheros just won't allow me to release it.  
And there are significant differences between the two code bases.

    Sam



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback-out1.mxes.net ([216.86.168.190]:3285 "EHLO
	fallback-in1.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367AbZFRJiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 05:38:50 -0400
Received: from mxout-03.mxes.net (mxout-03.mxes.net [216.86.168.178])
	by fallback-in1.mxes.net (Postfix) with ESMTP id 96E89164916
	for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 05:38:52 -0400 (EDT)
Message-ID: <4A3A0A9E.4060201@tuffmail.co.uk>
Date: Thu, 18 Jun 2009 10:36:30 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] rfkill: export persistent attribute in sysfs
References: <4A37A3FC.9060206@tuffmail.co.uk> <20090618031015.GF29569@khazad-dum.debian.net>
In-Reply-To: <20090618031015.GF29569@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Tue, 16 Jun 2009, Alan Jenkins wrote:
>   
>> + * can be read by userspace.  Persistent devices are expected to preserve
>> + * preserve their own state when suspended.
>>     
>
> You have "preserve" twice in there.
>
> Other than that,
>
> Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>   

I see the patches are already in wireless-testing and -next.  I'll send
an incremental patch to fix this one comment.



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4671 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab2EHTJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 15:09:15 -0400
Message-ID: <4FA96F4C.7010508@broadcom.com> (sfid-20120508_210921_526455_1A970624)
Date: Tue, 8 May 2012 21:09:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Franky Lin" <frankyl@broadcom.com>
cc: "Il Han" <corone.il.han@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: Remove an unused variable.
References: <1336458947-20698-1-git-send-email-corone.il.han@gmail.com>
 <4FA9606E.6000505@broadcom.com>
In-Reply-To: <4FA9606E.6000505@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2012 08:05 PM, Franky Lin wrote:
> On 05/07/2012 11:35 PM, Il Han wrote:
>> The variable val is not used afterward.
>> Remove the declaration and the assignment line of it.
>>
>> Signed-off-by: Il Han<corone.il.han@gmail.com>
>> ---
> 
> Thanks Il. Add John as recipient as well.
> 
> Acked-by: Franky Lin <frankyl@broadcom.com>
> 
> Regards,
> Franky

My rule of thumb:

use get_maintainer.pl script and address you patches to the given
maintainer (9 out of 10 you get a sensible maintainer from it).

So for this patch, send the patch to John Linville and CC linux-wireless
list and others you consider specially interested.

Gr. AvS


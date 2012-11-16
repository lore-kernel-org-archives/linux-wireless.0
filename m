Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3028 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab2KPO6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 09:58:53 -0500
Message-ID: <50A65443.2000101@broadcom.com> (sfid-20121116_155857_776532_135CFE5B)
Date: Fri, 16 Nov 2012 15:57:07 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Mahesh Palivela" <maheshp@posedge.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: VHT support, take 2
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
 (sfid-20121109_211702_930840_209B43F6)
 <1352492493.28302.7.camel@jlt4.sipsolutions.net>
 <50A4DB80.2020209@posedge.com>
 <1353072509.9490.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353072509.9490.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 02:28 PM, Johannes Berg wrote:
> On Thu, 2012-11-15 at 17:39 +0530, Mahesh Palivela wrote:
>
>> vht regulatory code already posted long back. After went through several
>> back n forth emails from Luis Rodriguez, accepted the patch.
>> But not commited anywhere.
>> Now I have to change that to match to new structs like chan_def etc from
>> the vht channel work patches you posted 5 days back.
>>
>> Also helper funcs to replace chan->flags bit checking to dynamically
>> check channel through regulatory
>
> Yeah, actually I'm not sure it's that easy. We'll also need per
> bandwidth TX power restrictions, raise the 40 MHz bandwidth restriction
> to 160 MHz (or get rid of it entirely), etc. That seems to require a new
> regulatory database format?

Luis discussed the regulatory framework during the wireless summit in 
Barcelona last week. My (possibly limited) recollection was that the 
current regulatory code can accommodate VHT limits as well. I assume 
that also includes the regulatory database format.

Gr. AvS



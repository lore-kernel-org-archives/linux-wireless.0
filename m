Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2998 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab2LCSz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 13:55:29 -0500
Message-ID: <50BCF57E.8020204@broadcom.com> (sfid-20121203_195534_168277_8D1F13C1)
Date: Mon, 3 Dec 2012 19:54:54 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Kalle Valo" <kvalo@adurom.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: [PATCH V2 v3.7] brcmsmac: handle packet drop on enqueuing
 correctly
References: <1353961396-7061-1-git-send-email-arend@broadcom.com>
 <50BC63E5.9020101@broadcom.com> <871uf7w6w0.fsf@purkki.adurom.net>
 <20121203183912.GE26027@tuxdriver.com>
In-Reply-To: <20121203183912.GE26027@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/2012 07:39 PM, John W. Linville wrote:
> On Mon, Dec 03, 2012 at 04:24:31PM +0200, Kalle Valo wrote:
>> Hi Arend,
>>
>> "Arend van Spriel" <arend@broadcom.com> writes:
>>
>>> What is keeping you from picking up this patch? Anything I should do?
>>> This V2 removed the no-op changes in ampdu.c that Seth indicated so...
>>
>> Most likely it's too late. Dave already told that that John's previous
>> pull request might not make it to 3.7.
> 
> Yes, that.  Also, given the merge difficulties this creates and the
> fact that Seth's patch is already queued for 3.8, maybe you should
> consider sending this for the 3.7 stable series when it opens?
> 
> John
> 

That was my plan when it would not get in for 3.7.0. I wanted it to go
to stable anyway as the fix is also needed for 3.6.x stable. Just wanted
to get it upstream fixed first.

For 3.8 the fix has been reworked on top of Seth patches and is in
wireless-next (c4dea35e brcmsmac: handle packet drop during transmit
correctly). Should I refer to that commit when submitting to stable
(although it is a slightly different patch).

Gr. AvS


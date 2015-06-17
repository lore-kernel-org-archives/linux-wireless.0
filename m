Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:29303 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbbFQVEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 17:04:00 -0400
Message-ID: <5581E0BA.2040400@broadcom.com> (sfid-20150617_230404_762714_8926A9DE)
Date: Wed, 17 Jun 2015 23:03:54 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: creating ap interface
References: <5581BEBA.1080500@broadcom.com>	 <1434568011.1884.42.camel@sipsolutions.net>	 <CACna6rwq6VB+mg2tLetmMQTA0xexbDwi=JdoBgHRxDB4EgeUeA@mail.gmail.com>	 (sfid-20150617_223255_654414_66333DC6) <1434573264.2594.0.camel@sipsolutions.net>
In-Reply-To: <1434573264.2594.0.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/15 22:34, Johannes Berg wrote:
> On Wed, 2015-06-17 at 22:32 +0200, Rafał Miłecki wrote:
>
>>>> When I create an AP interface using iw, it is followed by a change
>>>> interface back to managed mode. I added a WARN_ON to see where it came
>
>> I'm pretty sure it was for debugging purposes.
>
> Oops, clearly. Sorry about that.

Yup. Won't be submitting it :-p


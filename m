Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from r-mail1.rd.orange.com ([217.108.152.41]:44798 "EHLO
	r-mail1.rd.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3GIOfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 10:35:14 -0400
Message-ID: <51DC1F9D.7000705@Free.fr> (sfid-20130709_163518_057895_C11F60B3)
Date: Tue, 09 Jul 2013 16:35:09 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ralink 3290: still lots of misc errors reported by Iwconfig with
 3.10 + HD streaming on WiFi fails
References: <51DBEB0C.6040704@Free.fr> <20130709142202.GB3681@redhat.com>
In-Reply-To: <20130709142202.GB3681@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2013 04:22 PM, Stanislaw Gruszka wrote:
> On Tue, Jul 09, 2013 at 12:50:52PM +0200, Eric Valette wrote:
>> I just bought a HP netbook for my son equipped with this chipset. I
>> first tried linux 3.9.7, got WiFi working badly but working. Saw fix
>> for TX power in 3.9.9. WiFi became more reliable but still had a lot
>> of  TX, and MISC errors reported by iwconfig.  While laptop is now
>> usable for internet browsing, trying to play HD tv via XBMC +
>> tvheadend fails miserably due to WiFi data rate and WiFi errors
>> while other PC at home do play without problems.
>>
>> Saw the fix in 3.10 for TX errors and indeed the TX errors dropped
>> to 0. However, the MISC error count in turn rose (Downloading
>> linux-3.10.tar.xz on 3.10 reports 550 misc errors). So there is
>> still some problem with this chipset. I know support is experimental
>> but I would be glad to test any patchif possible on 3.9.x as on 3.10
>> I have no ATI driver available at the moment and thus HD decoding is
>> out of reach anyway.
>
> Do you mean that 3.10 perform better than 3.9.9 ? I do not see any
> rt2x00 fixes between 3.9 and 3.10 that are not yet applied on 3.9.9.
> I can see only some cleanups and new hardware support patches.

 From memory I think I had a lot of reported TX error with 3.9.9 and 
they are now gone with 3.10 but the number of misc error reported by 
iwconfig is still high with 3.10. But you are right the fix for TX is 
still in wireless git and does not seem to be in 3.10. As I checked 
several git trees I mist have been confused...


> Try to subscribe to rt2x00 mailing list,
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
> we post new patches there, but currently we do not have any pending
> RT3290 fixes.

OK. Next radical solution is to open the laptop and change for another 
half mini pcie card... Quite difficult to find one reliably even if 
there are some available on ebay.

Thanks for taking the time to respond...

--eric


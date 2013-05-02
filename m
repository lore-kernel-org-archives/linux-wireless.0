Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2981 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761170Ab3EBTRx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 15:17:53 -0400
Message-ID: <5182BBD4.9010701@broadcom.com> (sfid-20130502_211758_316167_F77274E8)
Date: Thu, 2 May 2013 21:17:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
 <51823A0E.8020005@broadcom.com>
 <1367489163.8298.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1367489163.8298.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2013 12:06 PM, Johannes Berg wrote:
> On Thu, 2013-05-02 at 12:03 +0200, Arend van Spriel wrote:
>
>> I tested the patch on x86 platform and was successful executing a
>> p2p_find, p2p_connect, and able to ping my peer. But....
>>
>> When I tried this a second time I got a lockdep warning about annotation
>> as brcmfmac tried to take a mutex during scan (p2p_find). Two minutes
>> later I got warning about rcu stalls. Not sure where to look.
>
> Me neither? :) What does it say?

crap. One time I get the lockdep warning/rcu stall and the next a null 
pointer access, but the stack trace is the same. Afraid this is a 
brcmfmac issue that I will have to look into it.

Gr. AvS


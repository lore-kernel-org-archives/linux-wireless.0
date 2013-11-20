Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4815 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3KTRbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 12:31:02 -0500
Message-ID: <528CF1C1.3090400@broadcom.com> (sfid-20131120_183109_753642_64304911)
Date: Wed, 20 Nov 2013 18:30:41 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] brcm80211: cleanup fixes and out-of-order fix
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
 <528C82A6.4000500@broadcom.com> <20131120162946.GC2220@tuxdriver.com>
In-Reply-To: <20131120162946.GC2220@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/13 17:29, John W. Linville wrote:
> On Wed, Nov 20, 2013 at 10:36:38AM +0100, Arend van Spriel wrote:
>> On 11/06/2013 11:07 PM, Arend van Spriel wrote:
>>> This series contains a couple of small cleanup fixes and one fix
>> >from Hante to get rid of out-of-order transmit seen doing UDP iperf.
>>>
>>> This series is intended for 3.13 if the merge window has not yet
>>> opened. It applies to the master branch of the wireless-next
>>> repository.
>>
>> This series was sent two weeks ago, but did not pop up in your
>> repos. Is it put in 3.14 queue?
>
> I still have the series.  The wireless-next tree is inactive until
> after -rc1 gets released.

Ok. So it will go into wireless-next for 3.14 after -rc1 release. I just 
was not sure whether it made it before the merge window. It looked a bit 
racy :-)

Regards,
Arend


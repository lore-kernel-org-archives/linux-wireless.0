Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbXF1GQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2007 02:16:15 -0400
Message-ID: <4683520D.3090809@redhat.com>
Date: Thu, 28 Jun 2007 08:15:41 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Matteo Croce <rootkit85@yahoo.it>
Subject: Re: [PATCH 0/4] airo fixes
References: <4682D323.2010605@redhat.com> <1183007181.3893.18.camel@xo-13-A4-25.localdomain>
In-Reply-To: <1183007181.3893.18.camel@xo-13-A4-25.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams skrev:
> On Wed, 2007-06-27 at 23:14 +0200, Michal Schmidt wrote:
>> Hello,
>>
>> this is a series of four patches for the airo driver:
>>
>> 1/4: airo: don't use the interface name so much before registration
>> 2/4: airo: delay parts of initialization until the netdev is up
>> 3/4: airo: disable the PCI device when unloading module
>> 4/4: airo: start with radio off
>>
>> The first two fix the race condition Matteo Croce was experiencing.
>> The third one fixes a bug I noticed during testing.
>> The last one saves some power when the card is not used.
> 
> These all look good to me, I might be able to find some time to
> runtime-test them too if you want more testing.
> 
> Dan

That would be nice. Thank you.
Michal

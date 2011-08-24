Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1790 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab1HXGfX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 02:35:23 -0400
Message-ID: <4E549B8A.20801@broadcom.com> (sfid-20110824_083526_656163_06A0B80F)
Date: Wed, 24 Aug 2011 08:34:50 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/8] brcmsmac fixes and driver cleanup
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
 <20110823201228.GC25977@kroah.com>
In-Reply-To: <20110823201228.GC25977@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2011 10:12 PM, Greg KH wrote:
> On Tue, Aug 23, 2011 at 02:13:52PM +0200, Arend van Spriel wrote:
>> With 3.1 kernel the crc8 and cordic library modules are available in the
>> staging tree. The brcmsmac driver now uses them. Some small fixes have
>> been made and the driver is made to work on the Sparc platform.
>>
>> This series applies to staging-next and depends on the following patch set:
>>
>> Message-ID:<1313415267-5264-1-git-send-email-arend@broadcom.com>
> All applied.
>
> That's everything that you have pending, right?  Anything I miss?
>
> thanks,
>
> greg k-h

Great. It was quite a number of patches. I did a diff between your tree 
and our internal one. Apart from the two community patches we are in 
sync so no misses. Thanks.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --



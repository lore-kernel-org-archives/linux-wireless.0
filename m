Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3422 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab1EVIXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 04:23:49 -0400
Message-ID: <4DD8C80A.5060700@broadcom.com> (sfid-20110522_102407_464430_F22039AC)
Date: Sun, 22 May 2011 10:23:38 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Dan Carpenter" <error27@gmail.com>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
 algorithm
References: <1306010973-5625-1-git-send-email-arend@broadcom.com> (
 sfid-20110521_225033_074451_F0976112)
 <1306017455.3389.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1306017455.3389.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2011 12:37 AM, Johannes Berg wrote:
> On Sat, 2011-05-21 at 22:49 +0200, Arend van Spriel wrote:
>
>> +/**
>> + * enum - CRC8 constants
>> + *
>> + * @CRC8_INIT_VALUE: Initial CRC8 checksum value
>> + * @CRC8_GOOD_VALUE: Good final CRC8 checksum value
>> + *
>> + * Constants for the crc8() function. Refer to its
>> + * documentation how to use these values.
>> + */
>> +enum CRC8 {
>> +	CRC8_INIT_VALUE	= 0xff,
>> +	CRC8_GOOD_VALUE	= 0x9f
>> +};
> These seem a little out of place, wouldn't that be specific to how the
> algorithm is used?

True, a different init value likely results in a different good value. 
However, the documentation of the crc8() function provides one possible 
use which makes use of these values. So it is provided as a convenience. 
Removal is easy of course, but I tend to keep it for those who are 
content with the proposed usage (not necessarily Broadcom :-D ).

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --



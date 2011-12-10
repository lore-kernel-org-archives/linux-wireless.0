Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1444 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1LJUSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 15:18:17 -0500
Message-ID: <4EE3BE7B.5030606@broadcom.com> (sfid-20111210_211820_882140_2EAFA580)
Date: Sat, 10 Dec 2011 21:18:03 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 05/23] bcma: add set/mask macros for 16-bit register
 access
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
 <1323385619-7454-6-git-send-email-frankyl@broadcom.com>
 <CACna6rwVVEYf0F6HZoMKrJg2NT3c4SPb6OH34LsTm8NR+BtsRA@mail.gmail.com>
In-Reply-To: <CACna6rwVVEYf0F6HZoMKrJg2NT3c4SPb6OH34LsTm8NR+BtsRA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 12:45 PM, Rafał Miłecki wrote:
> 2011/12/9 Franky Lin <frankyl@broadcom.com>:
>> From: Arend van Spriel <arend@broadcom.com>
>>
>> The BCMA header only had definitions for 32-bit register access. Used
>> those as a template for the 16-bit flavour. Also changed them to inline
>> functions to be on the safe side. As offset parameter is used twice there
>> would be a problem when used like this: bcma_set32(core, offset++, val);
>>
> 
> What is an advantage of static inline over define?
> 

Hi Rafał,

Apart from the example given in the commit message the CodingStyle
documentation states a preference for inline functions. One advantage I
can come up with is type checking by the compiler.

Gr. AvS


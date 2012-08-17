Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3980 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab2HQNrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2012 09:47:40 -0400
Message-ID: <502E4B70.5090900@broadcom.com> (sfid-20120817_154744_843787_4D6BEC9C)
Date: Fri, 17 Aug 2012 15:47:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Saul St. John" <saul.stjohn@gmail.com>
cc: linux-wireless@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] bcma: expose cc sprom to sysfs
References: <20120816190616.GE6726@eris.garyseven.net>
In-Reply-To: <20120816190616.GE6726@eris.garyseven.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 09:06 PM, Saul St. John wrote:
> On BCMA devices with a ChipCommon core of revision 31 or higher, the device
> SPROM can be accessed through CC core registers. This patch exposes the
> SPROM on such devices for read/write access as a sysfs attribute.
>
> Tested on a MacBookPro8,2 with BCM4331.
>
> Cc: Rafał Miłecki <zajec5@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Saul St. John <saul.stjohn@gmail.com>

Hi Saul,

I was still planning to come back to your reply on August 14. Just 
wanted to reply to this patch as I still feel it is a bad thing to open 
up the sprom as a whole. I can see the use-cases you mentioned as 
useful, but maybe we can get a specific solution for that.

Gr. AvS


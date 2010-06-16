Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42814 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab0FPNdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 09:33:09 -0400
Received: by pva4 with SMTP id 4so661721pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 06:33:08 -0700 (PDT)
Message-ID: <4C18D2A5.5080702@gmail.com>
Date: Wed, 16 Jun 2010 06:33:25 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	greg@kroah.com, linux-wireless@vger.kernel.org,
	Peter Stuge <peter@stuge.se>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2.6.32.y] ath9k: re-enable ps by default for new single
 chip families
References: <1276640359-25360-1-git-send-email-lrodriguez@atheros.com> <20100616081227.GA1118@boggieman>
In-Reply-To: <20100616081227.GA1118@boggieman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/2010 01:12 AM, Kristoffer Ericson wrote:
> On Tue, Jun 15, 2010 at 06:19:19PM -0400, Luis R. Rodriguez wrote:
>> commit 14acdde6e527950f66c084dbf19bad6fbfcaeedc upstream.
>>
>> The newer single chip hardware family of chipsets have not been
>> experiencing issues with power saving set by default with recent
>> fixes merged (even into stable). The remaining issues are only
>> reported with AR5416 and since enabling PS by default can increase
>> power savings considerably best to take advantage of that feature
>> as this has been tested properly.
>
> I havent had any issues lately. But that said Ive moved on to
> 2.6.33, 2.6.34 which seems to work fine. Believe you set
> to disabled by default on those?
>
> /Kristoffer
>

just tried to add this patch to the latest HEAD, but realized 
ath_set_hw_capab is missing(or I cant seem to grep it)
if you have a patch for the latest tree let me know I can see if I'm 
hitting anything like before.

Justin P. Mattock

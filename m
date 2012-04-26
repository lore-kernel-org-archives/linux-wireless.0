Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1107 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2DZMy5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 08:54:57 -0400
Message-ID: <4F994593.4060205@broadcom.com> (sfid-20120426_145619_364528_DDD061F2)
Date: Thu, 26 Apr 2012 14:54:43 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Joe Perches" <joe@perches.com>
Subject: Re: [PATCH 1/2] wireless: properly use pr_fmt()
References: <1335234998-31547-1-git-send-email-mcgrof@frijolero.org>
 <4F994349.1040607@broadcom.com>
In-Reply-To: <4F994349.1040607@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2012 02:44 PM, Arend van Spriel wrote:
> On 04/24/2012 04:36 AM, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez"<mcgrof@frijolero.org>
>>
>> pr_fmt() is either defined or we redefine it. Typically
>> drivers define it prior to including printk.h but this
>> is done under the assumption that no other subsystem
>> it uses has already defined pr_fmt(). In such cases
>> pr_fmt() should be undefined and redefined.
>>
>> Doing this properly shaves down compilation time quite
>> considerably.
>>
>> Signed-off-by: Luis R. Rodriguez<mcgrof@frijolero.org>
>
> Hi Luis,
>
> I actually recall some patches removing inclusion of printk.h sometime
> ago. Not sure what the motivation was, but I will start digging the git
> revision logs.
>
> Gr. AvS
>

Here it is: https://lkml.org/lkml/2011/5/25/331

Gr. AvS


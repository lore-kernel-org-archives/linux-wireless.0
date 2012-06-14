Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:63105 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2FNQpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 12:45:24 -0400
Message-ID: <4FDA1523.7090301@opentechinstitute.org> (sfid-20120614_184527_239494_7A059C53)
Date: Thu, 14 Jun 2012 12:45:23 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth frames
 on adhoc ifaces
References: <4FD8B5D4.8060305@opentechinstitute.org> <1339658006.4909.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339658006.4909.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/14/2012 03:13 AM, Johannes Berg wrote:
> On Wed, 2012-06-13 at 11:46 -0400, Will Hawkins wrote:
>> Hello all!
>>
>> This patch allows userspace applications to use nl80211 to register for
>> AUTH frames received on adhoc interfaces.
>>
>> Thanks,
>> Will
>>
>> Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
> 
> Thanks for the patch. Can I get you to write a better commit log? :-)
> 
> You should remove the "Hello" and "Thanks" portions, they shouldn't go
> into the kernel's commit log after all. And then, even if I already
> know, please explain in the commit log why you're making this change so
> the reason gets recorded in the kernel's commit log.

I submitted a v2 of this patch with a better commit log. Thanks for the
handholding. I'm obviously still new at this!

Will

> 
> Thanks,
> johannes
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

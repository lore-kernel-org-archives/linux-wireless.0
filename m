Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2196 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab2IJUlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 16:41:46 -0400
Message-ID: <504E5083.2030904@broadcom.com> (sfid-20120910_224150_038385_087E298C)
Date: Mon, 10 Sep 2012 22:41:39 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Seth Forshee" <seth.forshee@canonical.com>
Subject: Re: [PATCH 0/2] brcmsmac: fix for regulatory rules and flush
 callback
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <504DE996.4020709@broadcom.com> <20120910183335.GA2137@tuxdriver.com>
In-Reply-To: <20120910183335.GA2137@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2012 08:33 PM, John W. Linville wrote:
> On Mon, Sep 10, 2012 at 03:22:30PM +0200, Arend van Spriel wrote:
>> On 09/05/2012 11:49 AM, Arend van Spriel wrote:
>>> Two fixes intended for the wireless tree. The issue with the .flush() has
>>> been giving me a lot of email from RedHat's bugzilla server. Hope this
>>> patch will silence that ;-)
>>
>> Hi John,
>>
>> I should remove that smile above, but are you planning to take these
>> for v3.6. At least the first patch is a clear bug fix that I would
>> like
>> to have applied.
>>
>> Gr. AvS
>
> Arend,
>
> I held-off on these because of the continuing discussion...

Understood.

> I definitely 'feel your pain' re: Red Hat bugzilla and the second
> patch.  But I'm not sure it meets either the 'small' or 'obvious'
> tests, so I would prefer to leave it out for now.  I'll take the
> first one now.

Thanks. I wanted to make sure the first patch got in. While the second 
improves the runtime behavior, it does not address the root cause 
(whatever that is) so I agree to keep it out until I hammer it down.

> Thanks,
>
> John
>

Gr. AvS


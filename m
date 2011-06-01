Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1377 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389Ab1FAQXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 12:23:54 -0400
Message-ID: <4DE6678F.1020803@broadcom.com> (sfid-20110601_182400_638829_F3F6BA4C)
Date: Wed, 1 Jun 2011 09:23:43 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Roland Vossen" <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
 <BANLkTinwvwauMOMXiFnUTnDonfB2oSxdRw@mail.gmail.com>
In-Reply-To: <BANLkTinwvwauMOMXiFnUTnDonfB2oSxdRw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2011 04:59 AM, Rafał Miłecki wrote:
> 2011/6/1 Roland Vossen<rvossen@broadcom.com>:
>> Code cleanup. Removal of code that is not invoked.
>
> Have you heard of "Release early, release often"? It's something, we
> like here...

These are all changes that piled up during the merge window.

We had some issues previously with patch dependencies when sending 
patches out early and often, so we're trying to organize the patches a 
little better.  Perhaps we went a little to far with this set.  We'll 
try to find a better balance in the future.

> I've no idea who will try to review 83 patches :|
>
> And you didn't even send [00/83] with summary.
>

Yea, that's not good.  Will make sure to include a summary in the future.

Thanks,
- Henry


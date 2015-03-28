Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:56739 "EHLO aibo.runbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbbC1MkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 08:40:05 -0400
Message-ID: <5516A115.4040208@runbox.com> (sfid-20150328_134038_848310_B419B047)
Date: Sat, 28 Mar 2015 08:39:49 -0400
From: "M. Vefa Bicakci" <m.v.b@runbox.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jes.Sorensen@redhat.com, joe@perches.com,
	Larry.Finger@lwfinger.net, mail@beyermatthias.de
Subject: Re: [PATCH v3 01/15] staging: rtl8723au: Reformat whitespace to increase
 readability
References: <1426739958-18949-1-git-send-email-m.v.b@runbox.com> <1426739958-18949-2-git-send-email-m.v.b@runbox.com> <20150326121810.GA15960@kroah.com>
In-Reply-To: <20150326121810.GA15960@kroah.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/03/15 08:18 AM, Greg KH wrote:
> On Thu, Mar 19, 2015 at 12:39:04AM -0400, M. Vefa Bicakci wrote:
>> Adjust the whitespace in the signature, local variable declaration and
>> initialization parts of a number of functions to increase readability
>> in rtl8723au's rtw_security.c.
>>
>> v2: Make sure that the arcfour_encrypt function's argument list is split
>>     according to the kernel code style.
> 
> The "v2" stuff here should go below the --- line, otherwise it will show
> up in the changelog :(
> 
> Please fix these all up and resend.

Hello Greg,

Thank you for the review!

I have addressed your comment in my local repository and I hope to send the 4th
revision of the patches soon.

Thanks again,

Vefa

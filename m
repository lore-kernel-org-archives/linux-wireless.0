Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33697 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbbEZPb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 11:31:56 -0400
Message-ID: <556491E8.60606@lwfinger.net> (sfid-20150526_175305_092391_AD112503)
Date: Tue, 26 May 2015 10:31:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Joe Perches <joe@perches.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudip@vectorindia.org>,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	Stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
	Haggai Eran <haggai.eran@gmail.com>,
	Arek Rusniak <arek.rusi@gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call
 of del_timer_sync()
References: <1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net> <CAJ=9CzbPmo+f4zjY4CqQ7TsUENpwy+zHcpxeLTbAH0DAZSkqsQ@mail.gmail.com> <556268BC.5050807@lwfinger.net> <20150525091737.GQ4150@mwanda> <1432575448.2846.63.camel@perches.com> <20150526044611.GA3465@sudip-PC> <1432616108.2846.83.camel@perches.com> <20150526050212.GC3465@sudip-PC> <1432616879.2846.86.camel@perches.com> <20150526053022.GA4585@sudip-PC>
In-Reply-To: <20150526053022.GA4585@sudip-PC>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2015 12:30 AM, Sudip Mukherjee wrote:
> On Mon, May 25, 2015 at 10:07:59PM -0700, Joe Perches wrote:
>> On Tue, 2015-05-26 at 10:32 +0530, Sudip Mukherjee wrote:
>>> On Mon, May 25, 2015 at 09:55:08PM -0700, Joe Perches wrote:
>>>> On Tue, 2015-05-26 at 10:16 +0530, Sudip Mukherjee wrote:
>>>>> On Mon, May 25, 2015 at 10:37:28AM -0700, Joe Perches wrote:
>
>>> But for eudyptula, patches have to properly submitted to lkml and
>>> maintainers. And today I am here just because of eudyptula. My patches
>>> and contributions here, everything started with it. :)
>>
>> As far as I understand, the Eudyptula Challenge list has
>> internal mechanisms to nominally review patches before some
>> patch is submitted to lkml.
> well, yes, sort of. Submitting patch is task 10, and all the previous
> tasks will train people on creating patch, sending etc.
>>
>> The main point is that patches shouldn't be applied without
>> being submitted to a more widely read list.
> yes, and Eudyptula requires the participant to send patch to maintainer,
> lkml and relevant mailing list where outreachy specifies not to send to
> lkml. Next outreachy will start from September.

At a minimum, outreachy needs to require that patches are sent to the 
maintainer(s). I can understand not wanting to burden LKML, but getting 
defective patches into the kernel must be avoided.

Larry



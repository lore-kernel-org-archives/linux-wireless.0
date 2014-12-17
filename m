Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34485 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaLQUHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 15:07:08 -0500
Received: by mail-lb0-f169.google.com with SMTP id p9so13550939lbv.28
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 12:07:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548F7703.1060600@lwfinger.net>
References: <1418596754-24735-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141215103117.GC4856@mwanda> <wrfjbnn4vrqa.fsf@redhat.com>
 <CAFo99gZOr=1z8J_gNNRLXnKNBEiPCE_G3=ryaN5hAHvewHf0_w@mail.gmail.com> <548F7703.1060600@lwfinger.net>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Wed, 17 Dec 2014 21:06:45 +0100
Message-ID: <CAFo99gYbxu4Q3iorovukEZ8LE2ZMCx5TRDFKud7jmq_zJxd2=Q@mail.gmail.com> (sfid-20141217_210735_259727_3BF6DEB4)
Subject: Re: [PATCH] staging: rtl8723au: os_dep: usb_intf.c: Fix for possible
 null pointer dereference
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Ok, do a patch to remove it now.

Kind regards
Rickard Strandqvist


2014-12-16 1:04 GMT+01:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 12/15/2014 05:01 PM, Rickard Strandqvist wrote:
>>
>> Hi
>>
>> No the rtw_hw_resume23a() is not used anywhere.
>> I also do a check of all functions that are not used, but not in the
>> drivers/staging, I suspected that these might be under development and
>> used in the future.
>>
>> What do you want to do, who decides?
>
>
> The original developers of this code do not include any of the Linux
> maintainers. If you see an unused routine, submit a patch to delete it. If a
> maintainer thinks it should be kept, your patch will be NACKed, but that is
> pnot likely.
>
> Larry
>
>

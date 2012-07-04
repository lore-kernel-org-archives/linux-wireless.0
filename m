Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46549 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2GDAfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 20:35:04 -0400
Received: by pbbrp8 with SMTP id rp8so10091023pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 17:35:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF38EA9.8000709@gmail.com>
References: <1341350730-11037-1-git-send-email-xose.vazquez@gmail.com>
 <4FF38492.20003@gmail.com> <CAB=NE6VpCUr1v400bNa1R3Ns4S4QVUt-cjq8=XtoJY=U533Cig@mail.gmail.com>
 <4FF38EA9.8000709@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 3 Jul 2012 17:34:43 -0700
Message-ID: <CAB=NE6W7pAsTPfZ-pja6hJdRkcgdWCOnwgSPazfXTt+NE0Ve1A@mail.gmail.com> (sfid-20120704_023509_321136_68D32CD8)
Subject: Re: [wireless-regdb] [PATCH] wireless-regdb: Update regulatory rules
 for ES (Spain) on 5GHz and 2.4GHz
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 5:30 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> On 07/04/2012 01:59 AM, Luis R. Rodriguez wrote:
>
>> Please send a new patch and if you are going to convert something form
>> dBm to mW then please do that in *one* single patch so that it can
>> easily be read what changes you are *actually* making. That is one
>> patch to make a conversion in units that will not make any actual
>> changes, and then send another patch with all the verbiage you can use
>> to explain *why* you want the change you are making. You want the
>> commit log to have enough language so that if I forward the patch to a
>> regulatory person who has never read a patch they can read it.
>
>
> There was only one patch.
>
> The second mail was only a "Signed-off-by:", just in case.
>
>
>> The agreed upon "bar" for quality of regulatory patches was agreed
>> upon a while ago, for details see:
>>
>> http://marc.info/?l=linux-wireless&m=128414096127554&w=2
>
>
> Thank youuuuu
> http://wireless.kernel.org/en/developers/Regulatory#Mailing_list_for_regulatory_updates
> :-P
>
>
>> The more information you can provide the better.
>
>
> I believe  I sent enough.

Any chance you can just repost a v2 with the SOB on it?

  Luis

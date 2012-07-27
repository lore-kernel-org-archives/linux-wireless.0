Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:32779 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2G0OWy (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Fri, 27 Jul 2012 10:22:54 -0400
Received: by bkwj10 with SMTP id j10so1940521bkw.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 07:22:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120727101840.GA2436@redhat.com>
References: <1343372634-19870-1-git-send-email-machen@suse.com>
	<20120727101840.GA2436@redhat.com>
Date: Fri, 27 Jul 2012 22:22:44 +0800
Message-ID: <CALx5=V_GSs8xv0-OnEC-2h82E9LWVpRjd1UDyPE3+=etX0z29A@mail.gmail.com> (sfid-20120727_162302_354233_B0D9C424)
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	kevin.chou@mediatek.com, woody.hung@mediatek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

2012/7/27 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Fri, Jul 27, 2012 at 03:03:54PM +0800, Chen, Chien-Chia wrote:
>> This patch is going to fix the resuming failed from S3/S4
>> for rt3290 chip.
>>
>> Signed-off-by: Chen, Chien-Chia <machen@suse.com>
>> CC-by: Kevin Chou <kevin.chou@mediatek.com>
>
> Could you please post patches that compile? Also you did not set true
Compile ? you mean the *.o files and *.ko ?
> author of the patch. Additionally, since repost that patch with changes,
> you should mark version of the patch and provide information about
> changes, like for example here:
Hmm....I added the Author: Woody Hung <Woody.Hung@mediatek.com> but
don't know why it doesn't show here. :(

> http://marc.info/?l=linux-wireless&m=134338186523059&w=2
It makes sense to me. I will repost it and mark version of the patch.
> Still patch does not include registers/values names, but if providing
> such information is not possible, we will accept that.
Thanks, Ralink doesn't intend to give me the registers/values names.
> Thanks
> Stanislaw
>
>



-- 
Thank you.

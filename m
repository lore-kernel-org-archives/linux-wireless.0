Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:54688 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2G3IJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 30 Jul 2012 04:09:26 -0400
Received: by vbbff1 with SMTP id ff1so4345140vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2012 01:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120730073327.GB2395@redhat.com>
References: <1343372634-19870-1-git-send-email-machen@suse.com>
	<20120727101840.GA2436@redhat.com>
	<CALx5=V_GSs8xv0-OnEC-2h82E9LWVpRjd1UDyPE3+=etX0z29A@mail.gmail.com>
	<20120730073327.GB2395@redhat.com>
Date: Mon, 30 Jul 2012 16:09:12 +0800
Message-ID: <CALx5=V_ym1yRoyeFRL1cYWDFZprUyh7raqg5qxj9OES-Zdjj1g@mail.gmail.com> (sfid-20120730_100932_375806_C3D46B5B)
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	kevin.chou@mediatek.com, woody.hung@mediatek.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2012/7/30 Stanislaw Gruszka <sgruszka@redhat.com>:
> Hi
>
> On Fri, Jul 27, 2012 at 10:22:44PM +0800, Matt Chen wrote:
>> 2012/7/27 Stanislaw Gruszka <sgruszka@redhat.com>:
>> > On Fri, Jul 27, 2012 at 03:03:54PM +0800, Chen, Chien-Chia wrote:
>> >> This patch is going to fix the resuming failed from S3/S4
>> >> for rt3290 chip.
>> >>
>> >> Signed-off-by: Chen, Chien-Chia <machen@suse.com>
>> >> CC-by: Kevin Chou <kevin.chou@mediatek.com>
>> >
>> > Could you please post patches that compile? Also you did not set true
>> Compile ? you mean the *.o files and *.ko ?
>
> Patch does not compile:
>
> drivers/net/wireless/rt2x00/rt2800lib.c:5163: error: static declaration of ‘rt2800_enable_wlan_rt3290’ follows non-static declaration
> drivers/net/wireless/rt2x00/rt2800lib.h:212: note: previous declaration of ‘rt2800_enable_wlan_rt3290’ was here
> make[1]: *** [drivers/net/wireless/rt2x00/rt2800lib.o] Error 1
> make: *** [drivers/net/wireless/rt2x00/] Error 2
>
> How did you tested the patch ?
Ah......it must be my direct copy and past, I am working on V2 path, I
am working on building it now, make sure my v2 patch is fine to build.
>> > author of the patch. Additionally, since repost that patch with changes,
>> > you should mark version of the patch and provide information about
>> > changes, like for example here:
>> Hmm....I added the Author: Woody Hung <Woody.Hung@mediatek.com> but
>> don't know why it doesn't show here. :(
>
> So fix that. Post patch to yourself first to see if setting works.
I see. thanks.
> Stanislaw
>



-- 
Thank you.

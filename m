Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:33182 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2GWMfi (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 23 Jul 2012 08:35:38 -0400
Received: by bkwj10 with SMTP id j10so5189307bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 05:35:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120723112359.GA2567@redhat.com>
References: <1342667903-27314-1-git-send-email-machen@suse.com>
	<20120719145430.GA4231@redhat.com>
	<CALx5=V8Sz_CiqQvX-N1hscmpYa7GTO2YfukS8BJc1YChLFmd5Q@mail.gmail.com>
	<20120723112359.GA2567@redhat.com>
Date: Mon, 23 Jul 2012 20:35:31 +0800
Message-ID: <CALx5=V9Oxhdwsz_vMW4ng=Ci=OL=MAKSVBkvvJVsYBboU9U73w@mail.gmail.com> (sfid-20120723_143542_100310_81B53270)
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
From: Matt Chen <machen@suse.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: kevin.chou@mediatek.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2012/7/23 Stanislaw Gruszka <sgruszka@redhat.com>:
> Hi
>
> On Mon, Jul 23, 2012 at 03:01:08PM +0800, Matt Chen wrote:
>> >> +
>> >> +                     rt2800_register_write(rt2x00dev, 0x58, 0x018);
>> >> +                     udelay(REGISTER_BUSY_DELAY);
>> >> +                     rt2800_register_write(rt2x00dev, 0x58, 0x418);
>> >> +                     udelay(REGISTER_BUSY_DELAY);
>> >> +                     rt2800_register_write(rt2x00dev, 0x58, 0x618);
>> > We really like to know what those black magic numbers mean.
>> I have no idea, Ralink gave it to me for the fixing.
>
> So perhaps patch should be posted by Ralink developer, who can fix that
> accordingly?
>
> Also it's clear now that you are not the author of the patch. Would be
> good to indicate true author of the patch by adding "From:" and
> "Signed-off-by:" lines.
No, I am not, just help the Ralink RD to submit this patch. I've
already asked them who is the author of this and will add him/her for
the "From:" and "Signed-off-by" for  next submit. :)
> Thanks
> Stanislaw
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>



-- 
Thank you.

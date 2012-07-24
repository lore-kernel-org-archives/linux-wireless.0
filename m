Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42014 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab2GXGYq (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 24 Jul 2012 02:24:46 -0400
Received: by bkwj10 with SMTP id j10so5953483bkw.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 23:24:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120723112359.GA2567@redhat.com>
References: <1342667903-27314-1-git-send-email-machen@suse.com>
	<20120719145430.GA4231@redhat.com>
	<CALx5=V8Sz_CiqQvX-N1hscmpYa7GTO2YfukS8BJc1YChLFmd5Q@mail.gmail.com>
	<20120723112359.GA2567@redhat.com>
Date: Tue, 24 Jul 2012 14:24:35 +0800
Message-ID: <CALx5=V_SgL0jU9gzWsQTTzuLwGCA7DoiRUH8hxGP2iTKiRdVag@mail.gmail.com> (sfid-20120724_082450_196413_F41EA508)
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : fix rt3290 resuming failed.
From: Matt Chen <machen@suse.com>
To: kevin.chou@mediatek.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

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
This upper meanning of register value part would need your help for
explanation.
> So perhaps patch should be posted by Ralink developer, who can fix that
> accordingly?
>
> Also it's clear now that you are not the author of the patch. Would be
> good to indicate true author of the patch by adding "From:" and
> "Signed-off-by:" lines.
>
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

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34249 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbZDGJZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 05:25:04 -0400
Received: by fxm2 with SMTP id 2so2236738fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 02:25:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239062777.4705.30.camel@maxim-laptop>
References: <1239062777.4705.30.camel@maxim-laptop>
Date: Tue, 7 Apr 2009 12:25:00 +0300
Message-ID: <b25312890904070225t44f72ecdsd87a29f7fed341b8@mail.gmail.com> (sfid-20090407_112508_992390_D89A7B5E)
Subject: Re: What is needed to inplement a AP support in a driver?
From: Rami Rosen <roszenrami@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
> Why iwl3945 still doesn't support AP mode?
see also this patch, titled: "wlwifi: disable AP mode"

http://www.spinics.net/lists/linux-wireless/msg24688.html

Regards,
Rami Rosen





On Tue, Apr 7, 2009 at 3:06 AM, Maxim Levitsky <maximlevitsky@gmail.com=
> wrote:
> I recently found that now ath5k supports AP mode.
> I also found that most of the work is now done in userspace.
>
> Since many drivers including my IWL3945 support sending beacons for I=
BSS
> (strictly speaking userspace can send them too, but this is =A0sub
> optimal), what else driver must support for AP?
>
> Sending to several stations ? (IBSS already has this), have several
> virtual devices (this is optional feature), what else?
>
> Why iwl3945 still doesn't support AP mode?
>
> If I patch it to support it (just add ap to list of allowed modes) wi=
ll
> it work? (I soon anyway try out....)
>
> Best regards,
> =A0 =A0 =A0 =A0Maxim Levitsky
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

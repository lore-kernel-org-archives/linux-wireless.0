Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55536 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2BTEue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Feb 2012 23:50:34 -0500
Received: by vcge1 with SMTP id e1so3397222vcg.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2012 20:50:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120217141504.GA31438@spatula.l.unchti.me>
References: <20120217141504.GA31438@spatula.l.unchti.me>
Date: Mon, 20 Feb 2012 10:20:33 +0530
Message-ID: <CAD2nsn1g7MB1Pw-6jen-ABSP51f6YaOjB3N816QNYB36esDtwQ@mail.gmail.com> (sfid-20120220_055037_823399_E86416AD)
Subject: Re: minstrel rate statistics
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Benjamin Kiessling <mittagessen@l.unchti.me>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 17, 2012 at 7:45 PM, Benjamin Kiessling
<mittagessen@l.unchti.me> wrote:
> Hi,
>
> I know it sounds silly but I am unable to find the rc_stats file for
> minstrel in my debugfs. I've been using an older kernel (2.6.35) and
> recently ported a few patches to the current wireless-testing tree, but
> after the upgrade there is only the rc_stats file of ath9k.
> I followed the rate_control_add_sta_debugfs() path and couldn't find any
> obvious wrong code. Is this a known problem or am I just too stupid to
> find it?

may be you should disable ath9k rate control  and enable minstrel in
your .config.

>
> Regards,
> Benjamin Kiessling



-- 
thanks,
shafi

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38076 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0J2V2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 17:28:00 -0400
Received: by qyk12 with SMTP id 12so7162023qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 14:27:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <694082.86488.qm@web56803.mail.re3.yahoo.com>
References: <201010292202.25486.s.L-H@gmx.de> <694082.86488.qm@web56803.mail.re3.yahoo.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 29 Oct 2010 23:27:38 +0200
Message-ID: <AANLkTimnuHM3E3G=d+R4-b=1NDkdEQ9jkbQsqB9ASiEC@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 29, 2010 at 10:26 PM, Walter Goldens
<goldenstranger@yahoo.com> wrote:
>> With both devices the connection is stable and quite
>> performant (~9 MB/s,
>> short distance, little channel overlap) against an Atheros/
>> athk9 based
>> router running OpenWrt (HT20 && HT40-, b/g/n). In
>> comparison to rtl8192su
>> the authentification handshake succeeds a lot quicker and
>> without needing
>> retries, performance is comparable.
>
> Now, that we're in the habit of adding staging drivers to compat-wireless, shouldn't this one follow the likes of ath6kl and brcm80211? Surely lots of users will benefit from this.

AFAIK we only add staging drivers that will eventually move out of
staging. r8712 has no chance of ever leaving staging; a completely new
driver needs to be written (because it isn't mac80211-based).

>
> Walter
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

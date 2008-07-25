Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:8584 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYGYQBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 12:01:17 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2100581waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2008 09:01:16 -0700 (PDT)
Message-ID: <69e28c910807250901q1f5924ambeb30a15e785b05a@mail.gmail.com> (sfid-20080725_180120_784072_FE5A9055)
Date: Fri, 25 Jul 2008 18:01:16 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: WLAN regression before this morning
Cc: free_beer_for_all@yahoo.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4889F7D6.4010706@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <761713.15647.qm@web46115.mail.sp1.yahoo.com>
	 <4889F7D6.4010706@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 25, 2008 at 5:57 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> I too have a problem with wireless in the current 2.6.26-gitX kernels. If
> you have done the git pull, you can try bisecting to find the problem. Use
> 'git bisect good v2.6.26' to mark a known good point. If you don't wish to
> take the time bisecting, then issue a 'git checkout v2.6.26'. That should
> give you a kernel that works.
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I am also seeing problems - although I can connect to networks (with
zd1211rw, ath5k & sometimes with b43), it disconnects after about 2
minutes with a sudden "Removed STA"/"Destroyed STA" pair (no "assume
out of range" or anything). However, if I use wpa_supplicant to
connect to wepped networks (rather than just "iwconfig wlan0 essid
<ESSID> key s:<ASCII key>"), the problem goes away, and the connection
is stable for hours.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

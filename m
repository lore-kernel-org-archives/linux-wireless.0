Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:48225 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbZJFTbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 15:31:20 -0400
Received: by fxm27 with SMTP id 27so3986982fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 12:30:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACB91E7.5010405@penny.prima.de>
References: <4ACB91E7.5010405@penny.prima.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 6 Oct 2009 21:30:23 +0200
Message-ID: <69e28c910910061230s47fdf9b9sdb9790497704b288@mail.gmail.com>
Subject: Re: Bleeding Edge b43 dated since 30 of september no longer working &
	today does not even compile.
To: Riffer <riffer@penny.prima.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 8:52 PM, Riffer <riffer@penny.prima.de> wrote:
> Hello!
>
> The problem is described in the topic.
>
> Symptons:
>
> The driver gets loaded and all depending drivers too but the wireless
> device does not come up (iwconfig shows nothing, "ADDRCONF(NETDEV_UP):"
> does not follow in /var/log/messages after modprobing).
>
> Any hints for me? Maybe a new functionality that has to be triggered?
>
> I am using the bleeding drivers on a Compaq 615 Notebook having PCI ID
> 14e4:4315 (Broadcom) under Ubuntu 9.04 with kernel
> 2.6.30-02063006-generic AMD64.
>

That's probably "wext: refactor".

Try connecting manually using iw (not iwconfig).

> Currently I am testing the bleeding edge driver nearly every day because
> I am a very curious man :-) and my hope is to one day find the best
> (fast and stable) wireless driver I can get for my notebook ;-)
>
> The most stable driver at the moment (for me) is the archive from the
> 16th of september and as you can read here
> http://forums.opensuse.org/2045067-post38.html bleeding edge had already
> a failure that stopped working from 17th to 26th of september (for me)
> where Larry pointed to a problem with cfg80211 (I am using WPA2).
>
> Another problem is that the archive from today can not be compiled:
>
> /home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/main.o
> In file included from
> /home/riffer/bleeding/compat-wireless-2009-10-06/include/net/mac80211.h:22,
>                 from
> /home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/ath.h:22,
>                 from
> /home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/main.c:20:
> /home/riffer/bleeding/compat-wireless-2009-10-06/include/net/cfg80211.h:1146:
> Fehler: »ETHTOOL_BUSINFO_LEN« ist hier nicht deklariert (nicht in einer
> Funktion)
> (translation:
> Error »ETHTOOL_BUSINFO_LEN« is not declared here (not in a function))
>
> best regards
>
> p.s.:
> I am only a user and not a developer. If my posting to this mailing-list
> is a mistake please tell me!!!
> --
> Riffer
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

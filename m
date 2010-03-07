Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56463 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0CGX7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 18:59:13 -0500
Received: by fxm19 with SMTP id 19so5865310fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 07 Mar 2010 15:59:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20100308T002346-575@post.gmane.org>
References: <loom.20100308T002346-575@post.gmane.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 8 Mar 2010 00:58:51 +0100
Message-ID: <69e28c911003071558v75cfe8aeq77644796a990434a@mail.gmail.com>
Subject: Re: ath9k: ar9220 does rx but no tx on antenna B
To: doddel <subscriptions@stroomer.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 8, 2010 at 12:38 AM, doddel <subscriptions@stroomer.com> wrote:
> in experimenting with writing antenna control for ath9k from user nl80211 user
> space found experimentally, verified with several R52n miniPCI ar9220 boards,
> that the current ath9k does not transmit on antenna B but does receive. Only on
> antenna A association/authentication and communication is possible.
> Have tried all sorts of settings for registers $8004 (AR_STA_ID1) masks
> 200000/40000/80000/400000 and $8058 (default antenna) and enabling/disabling
> ccmp and cck diversity but cannot get antenna B to transmit.
> What is the proper way to switch between
> 1) mimo 80211.n operation and
> 2) single antenna no-diversity operation, or
> 3) sectored operation giving all available antennas some airtime and beacons and
> answering on basis of best reception results ?
> As said current ath9k seems not to initialize the ar9220 properly for mimo mode
> on the R52n board that has two PAs but now only can use one.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Isn't AR9220 an 1T2R device?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

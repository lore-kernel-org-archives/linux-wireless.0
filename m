Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62773 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab0EYTIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 15:08:34 -0400
Received: by pwi2 with SMTP id 2so1200393pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 12:08:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
References: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 25 May 2010 12:08:14 -0700
Message-ID: <AANLkTikUhVoBKe95N_kkpXvSEsr845viGp5IhHZTVN2n@mail.gmail.com>
Subject: Re: wireless-regdb: A band is missing for IL
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael, please review and let us know what you think.

  Luis

On Tue, May 25, 2010 at 12:03 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> According to http://en.wikipedia.org/wiki/List_of_WLAN_channels#5.C2.A0GHz_.28802.11a.2Fh.2Fj.2Fn.29
>
> Channels 34 - 64 are allowed in 20 Mhz in Israel. This is not what is
> written in db.txt:
>
> country IL:
>         (2402 - 2482 @ 40), (N/A, 20)
>
> This wikipedia page relies on an official page from the Israel
> Ministry of the Communication.
>
> Emmanuel Grumbach
> egrumbach@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

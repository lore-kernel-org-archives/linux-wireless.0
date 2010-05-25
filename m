Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10095 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab0EYUjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 16:39:11 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 13:39:11 -0700
From: David Quan <David.Quan@Atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Michael Green <Michael.Green@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 25 May 2010 13:39:09 -0700
Subject: RE: wireless-regdb: A band is missing for IL
Message-ID: <93781E992CBA7843962D8B0E7D683F3C11178EC0E4@SC1EXMB-MBCL.global.atheros.com>
References: <AANLkTimkpbans5mUObR8PWzf2-Uh0K-cZVVg0HjNxnSv@mail.gmail.com>
 <AANLkTikUhVoBKe95N_kkpXvSEsr845viGp5IhHZTVN2n@mail.gmail.com>
In-Reply-To: <AANLkTikUhVoBKe95N_kkpXvSEsr845viGp5IhHZTVN2n@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Israel follows ETSI3_WORLD,
 this means 

Unii1 + Unii2 is supported. Unii2 requires DFS for APs.

2ghz Ch1-13 supported.
 

-----Original Message-----
From: Luis R. Rodriguez [mailto:mcgrof@gmail.com] 
Sent: Tuesday, May 25, 2010 12:08 PM
To: Emmanuel Grumbach; Michael Green; David Quan
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: A band is missing for IL

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

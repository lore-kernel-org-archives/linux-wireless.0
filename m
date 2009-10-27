Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:51991 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbZJ0QWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:22:23 -0400
Received: by iwn8 with SMTP id 8so241879iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 09:22:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256660178-5863-1-git-send-email-lrodriguez@atheros.com>
References: <1256660178-5863-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 27 Oct 2009 09:22:07 -0700
Message-ID: <43e72e890910270922g555981tfb0a9b471ccaa662@mail.gmail.com>
Subject: Re: [PATCH v2] wireless-regdb: update US rules for 5600 MHz - 5650
	MHz
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Green <Michael.Green@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2009 at 9:16 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> The FCC is trying to assist airports that use Terminal Doppler
> Weather Radar (TDWR) systems in avoiding interference with
> some outdoor wireless systems operating in the 5.4 GHz
> (5470 MHz - 5725 MHz) band. One of the things they have decided
> on is to disallow operation on the 5600 MHz - 5650 MHz frequency
> range inclusive. What this means in practice is 5 GHz 802.11
> devices programmed to operate in the US will have these
> channels now disabled:
>
>  * 5600 MHz [120] (disabled)
>  * 5620 MHz [124] (disabled)
>  * 5640 MHz [128] (disabled)
>
> This is documented on the FCC Knowledge based Publication
> Number: 443999 [1]
>
> [1] https://fjallfoss.fcc.gov/oetcf/kdb/forms/FTSSearchResultPage.cfm?switch=P&id=41732

And actually -- on second though I'm reviewing if we can just use
NO-IBSS, PASSIVE-SCAN, DFS on this frequency range. So please hold on
this.

  Luis

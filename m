Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39838 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab0HCADN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 20:03:13 -0400
Received: by iwn7 with SMTP id 7so4549245iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 17:03:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C56B234.3040209@marvell.com>
References: <4C56B234.3040209@marvell.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Aug 2010 17:02:51 -0700
Message-ID: <AANLkTimSj-X3VEF-OjhV8fQfs5SLCAWR1tLdQGiLttMV@mail.gmail.com>
Subject: Re: wireless-regdb: Why crda db.txt disallows 40Mhz BW on Channel
	12-13 for JP?
To: yogeshp <yogeshp@marvell.com>,
	Michael Green <Michael.Green@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 2, 2010 at 4:55 AM, yogeshp <yogeshp@marvell.com> wrote:
> Hello All,
>
> Crda db.txt has following entries for JP:
>        (2402 - 2472 @ 40), (N/A, 20)
>        (2457 - 2482 @ 20), (N/A, 20)
>
> Why are channel 12 and 13 for JP disallowed to operate in 40Mhz by this file?
>
> As per Annex 11J of latest 802.11n spec, for Japan, channel 1-7 are allowed in HT40+ and
> channel 5-13 are allowed in HT40- mode.

Do you mean Section 11J.1? That stuff defines a regulatory class, its
not a regulatory text though. Linux dynamically computes the HT40+ or
HT40- allowed channel map based on frequency ranges supported and the
max allowed bandwidth for its frequency ranges.

Michael, can you confirm if HT0 is allowed on the 2.4 GHz band in JP ?

  Luis

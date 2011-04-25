Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59332 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758797Ab1DYSu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:50:27 -0400
Received: by iyb14 with SMTP id 14so2059403iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 11:50:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DB550A3.9040204@t-online.de>
References: <4DB550A3.9040204@t-online.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Apr 2011 11:50:07 -0700
Message-ID: <BANLkTim10DXkLbMvkQ2fFKxOoZm2dfNeHQ@mail.gmail.com> (sfid-20110425_205030_516600_6CD4B882)
Subject: Re: Prefer specific wireless standard
To: =?UTF-8?Q?Richard_Sch=C3=BCtz?= <r.schtz@t-online.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 25, 2011 at 3:44 AM, Richard Schütz <r.schtz@t-online.de> wrote:
> I want to prefer 5 GHz access points over 2.4 GHz access points in an
> environment where both types are available with the same SSID, because the
> load on the 5 GHz cells is much lower and they also support HT40. Is there a
> way to reach this without forcing the client to connect to one specific
> access point and as a result losing roaming capability?

Sounds like supplicant heuristics you can work on.

  Luis

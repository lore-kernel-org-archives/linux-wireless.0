Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:52862 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbZGaSU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:20:27 -0400
Received: by gxk9 with SMTP id 9so3973403gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:20:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0907311118o5460952xd3462b14375eeb72@mail.gmail.com>
References: <20090731180238.GA7963@makis> <43e72e890907311111k10cce08et84510866c68e0297@mail.gmail.com>
	<40f31dec0907311118o5460952xd3462b14375eeb72@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 11:20:07 -0700
Message-ID: <43e72e890907311120r76d3db6et91128ccbc3a90c63@mail.gmail.com>
Subject: Re: [PATCH 1/4]: Check EEPROM before tweaking SERDES
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 11:18 AM, Nick Kossifidis<mickflemm@gmail.com> wrote:
> 2009/7/31 Luis R. Rodriguez <mcgrof@gmail.com>:
>>
>> Can the changes for the code be done before the move, or after so that
>> way the actual code changes to the section can be easily readable?
>>
>
> Since we use EEPROM infos we must move this after eeprom initialization.

Yes, but my point is a move can be done in one patch, changes to that
code in a separate patch, to help understand what is going on during
patch review.

  Luis

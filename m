Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:18833 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbYCYPwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:52:36 -0400
Received: by wr-out-0506.google.com with SMTP id c48so2330305wra.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 08:52:29 -0700 (PDT)
Message-ID: <b6c5339f0803250852k6217a793w81321b3ca5605de8@mail.gmail.com> (sfid-20080325_155239_336193_5E5DE765)
Date: Tue, 25 Mar 2008 11:52:28 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: ath5k aborts wireless connections
Cc: "Helge Deller" <deller@gmx.de>, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com, mickflemm@gmail.com
In-Reply-To: <20080324194443.GA16065@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200803221129.59090.deller@gmx.de>
	 <20080324194443.GA16065@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  > wlan1: RX disassociation from 00:50:18:3b:2b:04 (reason=1)
>  > wlan1: disassociated
>  > wlan1: deauthenticate(reason=14)
>
>  "Message integrity field (MIC) failure" -- doesn't look good.
>
>  I've seen a few reports of data corruption with ath5k.  Maybe it is
>  clobbering its own frames too?

I get exactly this symptom as well, but with the 5424 and the changes
queued for 2.6.26.  I had just assumed it was because the 5424
calibration etc. isn't fully understood yet.  This appears to be a
5212 though, so perhaps fixing it here would fix it for both.

-Bob

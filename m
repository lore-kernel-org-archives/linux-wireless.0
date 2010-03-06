Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64877 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0CFP1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 10:27:14 -0500
Received: by bwz22 with SMTP id 22so1587875bwz.28
        for <linux-wireless@vger.kernel.org>; Sat, 06 Mar 2010 07:27:13 -0800 (PST)
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH] ath9k_htc: Add ath9k_htc driver
References: <19335.43241.887933.207404@gargle.gargle.HOWL>
	<1267209201.30426.8.camel@mj>
	<43e72e891002261042s587f9fb8g9f491b1bac363582@mail.gmail.com>
	<1267233595.2835.20.camel@mj>
	<19336.44484.226966.463482@gargle.gargle.HOWL>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 06 Mar 2010 17:27:09 +0200
In-Reply-To: <19336.44484.226966.463482@gargle.gargle.HOWL> (Sujith's message of "Sat\, 27 Feb 2010 10\:59\:40 +0530")
Message-ID: <87hboteaia.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith <Sujith.Manoharan@atheros.com> writes:

>> The original patch should be run through checkpatch.pl.  In addition to
>> overly long lines, there are some other formatting issues.
>
> I thought that the default was 106 (or 132 ?) these days ..

>From CodingStyle:

"The limit on the length of lines is 80 columns and this is a strongly
preferred limit."

And I fully agree with that. It's easier to read code that way.

-- 
Kalle Valo

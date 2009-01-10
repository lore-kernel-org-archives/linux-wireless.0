Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:61907 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZAJXPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 18:15:02 -0500
Received: by wf-out-1314.google.com with SMTP id 27so10626122wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jan 2009 15:15:01 -0800 (PST)
Message-ID: <b6c5339f0901101515q48703b16o82d7550492dd34a5@mail.gmail.com> (sfid-20090111_001510_213355_31312A0F)
Date: Sat, 10 Jan 2009 18:15:01 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: darklight <darklight.xdarklight@googlemail.com>
Subject: Re: [PATCH] ath5k: ignore the return value of ath5k_hw_noise_floor_calibration
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
In-Reply-To: <888a464d0901091721l6657e755vbfe5bae0367f6413@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <888a464d0901091721l6657e755vbfe5bae0367f6413@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 9, 2009 at 8:21 PM, darklight
<darklight.xdarklight@googlemail.com> wrote:
> hi,
>
> some weeks ago Felix Fietkau posted a patch for the "ath5k phy0:
> unsupported jumbo" warnings (see here:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/23430 )
> I just had the same problem - after applying Felix' patch the warnings
> went down from 50-100 per day to 5.

It's already in Linus' tree for 2.6.29 (CCed stable@kernel.org).

Greg / stable, can you take 8b0162a3dc5c30e862b7a73da29e32de3170f5e4 for
2.6.28.X?

(It's not unsupported jumbo warnings, it's for noise floor calibration
failures, as in the subject of this email.)

-- 
Bob Copeland %% www.bobcopeland.com

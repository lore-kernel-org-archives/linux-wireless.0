Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42328 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZHaT15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 15:27:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
Date: Mon, 31 Aug 2009 21:27:55 +0200
Cc: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A9BFCCB.6040808@ufra.edu.br> <4A9C0ADC.6050607@ufra.edu.br> <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
In-Reply-To: <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908312127.57610.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 31 August 2009 20:26:22 Hin-Tak Leung wrote:
> It would appear that the rw driver's ieee80211->mac80211 conversion
> has broken big- endian platforms, at a first guess.

Last time I tested the device worked fine on my powerbook with zd1211rw/mac80211.
But that's maybe two or three release cycles in the past.

-- 
Greetings, Michael.

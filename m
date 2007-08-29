Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.239]:27052 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXH2SBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 14:01:36 -0400
Received: by nz-out-0506.google.com with SMTP id s18so222428nze
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2007 11:01:35 -0700 (PDT)
Message-ID: <9e4733910708291101i3783a8b1l38f0d5cfb0c2863d@mail.gmail.com>
Date: Wed, 29 Aug 2007 14:01:34 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Cc: "Christoph Hellwig" <hch@infradead.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <3208.1188408545@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <2713029743177393055@pripojeni.net>
	 <7515194658758617@pripojeni.net>
	 <20070828171155.GC29343@infradead.org>
	 <3208.1188408545@turing-police.cc.vt.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/29/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> The heck with "good idea" - it's unclear to me if Jiri is even *allowed*
> to remove the BSD/other license.   Jiri can release *his* code as GPLv2
> only, but I suspect the files as a whole really should be dual BSD/GPLv2,
> due to the numerous other stakeholders in those files.

This mess has been occurring in the kernel for years. The DRM graphics
drivers are used in both BSD and Linux. It is quite easy to contribute
something to this code via LKML and think you are doing it under the
GPL. Doesn't a patch against the kernel have to be GPL? When these
patches get pulled back into BSD and distributed with it, did BSD get
infected with the GPL? AFAIK this has never been legally sorted out.

-- 
Jon Smirl
jonsmirl@gmail.com

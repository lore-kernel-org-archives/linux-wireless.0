Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62888 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423096Ab2KNRtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 12:49:47 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so428152iay.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2012 09:49:47 -0800 (PST)
Date: Wed, 14 Nov 2012 12:49:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Sam Leffler <sleffler@google.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: RX timestamp is reported at end of frame
Message-ID: <20121114174940.GA22375@localhost> (sfid-20121114_184951_243079_FE95904F)
References: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
 <CAJ-Vmom4Q9ToOokeLf91tSDmmPDehcqfofuPu=wL+=Pf4fUr_g@mail.gmail.com>
 <20121112192859.GB6842@localhost>
 <CA+yqC4ZkeKgLKoPh18f1qDyLuOGf22GyL92+suca+gveoq7ZVw@mail.gmail.com>
 <20121113043226.GA4064@localhost>
 <CA+yqC4bFBFBccmeHWOaQHP0E=A0OWk+uef2ASdmLmR6pJfXRGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+yqC4bFBFBccmeHWOaQHP0E=A0OWk+uef2ASdmLmR6pJfXRGw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 13, 2012 at 08:27:43AM -0800, Sam Leffler wrote:
> It's close enough that if you adjust by the air time for the frame
> you'll get an accurate measure of when the preamble was received at
> the sta--at least accurate enough for me to synchronize clocks over
> 100+ km.  Details are available if you search and the code has been in
> freebsd for many years...

Indeed, that was a good read; thanks for the pointer.

-- 
Bob Copeland %% www.bobcopeland.com

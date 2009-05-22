Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out2.libero.it ([212.52.84.102]:39998 "EHLO
	cp-out2.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZEVKMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 06:12:07 -0400
Date: Fri, 22 May 2009 12:12:00 +0200
Message-Id: <KK1J00$BAC7E4518757B17D1805E790669D6D1D@libero.it>
Subject: Re: mac80211: TDMA approach feasible?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
From: "ffileppo" <ffileppo@libero.it>
To: "kalle\.valo" <kalle.valo@iki.fi>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> > I was wondering if with mac80211 is now possible (and what effort is
> > needed) to implement a TDMA approach. In particular I would like to:
> > override 802.11 MPDU frame format, eliminate RTS/CTS exchange,
> > eliminate automatic ACK and retransmission, eliminate virtual carrier
> > sense (NAV), control PHY clear channel assessment and control
> > transmission backoff.
> 
> Most of this is usually implemented in firmware, so you need access to
> firmware sources.
> 

Hi,
thanks for your answer.

If these features are implemented in firmware, it should be possible to modify them if using for example Ath5k (which is a completely FOSS Linux driver) Right? Could you give me any directions?

Talking about the TDMA implementation I was wondering if it is possible to achieve a time granularity of 1?s using commercial-of-the-shelf wifi cards (e.g. atheros ones).

I would appreciate any ideas or thoughts on this matter.

Thank you,

Francesco


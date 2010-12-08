Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43432 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0LHQIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 11:08:35 -0500
Received: by vws16 with SMTP id 16so1143294vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 08:08:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012061714.15863.br1@einfach.org>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com>
	<201012061714.15863.br1@einfach.org>
Date: Wed, 8 Dec 2010 11:08:34 -0500
Message-ID: <AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com>
Subject: Re: ath5k: Weird Retransmission Behaviour
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: Jonathan Guerin <jonathan@guerin.id.au>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 3:14 AM, Bruno Randolf <br1@einfach.org> wrote:
> But it seems weird that there are so many retransmissions. The default maximum
> numbers of retransmissions should be 7 for short frames and 4 for long frames
> (dot11[Short|Long]RetryLimit), and this is what is set as defaults in mac80211
> (local->hw.conf.short_frame_max_tx_count). Seems we are getting many
> retransmissions from minstel, i added some debug prints:
>

I posted a patch for this about a week ago to linux-wireless.

AFAICT minstrel doesn't use these configuration parrameters
at all (but PID does).

-- 
Bob Copeland %% www.bobcopeland.com

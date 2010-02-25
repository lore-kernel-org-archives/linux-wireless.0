Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34657 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100Ab0BYRvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 12:51:36 -0500
Received: by pwj8 with SMTP id 8so5825669pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 09:51:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6b5e31691002250640k154a1f22xa46bac547c69b250@mail.gmail.com>
References: <6b5e31691002250640k154a1f22xa46bac547c69b250@mail.gmail.com>
Date: Thu, 25 Feb 2010 12:51:32 -0500
Message-ID: <b6c5339f1002250951q7ad35de6g2a15f7c77e454b9a@mail.gmail.com>
Subject: Re: Ath5k and Retransmissions (Retries)
From: Bob Copeland <me@bobcopeland.com>
To: Andrew Blaich <ablaich@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 25, 2010 at 9:40 AM, Andrew Blaich <ablaich@gmail.com> wrote:
> Hi everyone,
>
>   I have been attempting, unsuccessfully, to alter the number
> retransmissions any particular transmission rate uses.  My card is
> reported as an AR5414 (Atheros) and the ath5k driver is being loaded.

What exactly are you changing?  The MRR array determines how many
retries there are for a given packet (hint, each packet has a
set of 4 different rates and each rate has its own retry count).
The driver also tells mac80211 the max number of retries.

-- 
Bob Copeland %% www.bobcopeland.com

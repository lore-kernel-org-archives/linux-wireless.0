Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932219AbdEKLjG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 07:39:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: ath10k@lists.infradead.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
References: <20170323133048.30062-2-sw@simonwunderlich.de>
        <1811221.G4Vz0DPyQ8@prime>
        <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de>
        <1863250.VEhGCjvYY0@prime>
Date: Thu, 11 May 2017 14:38:58 +0300
In-Reply-To: <1863250.VEhGCjvYY0@prime> (Simon Wunderlich's message of "Tue,
        09 May 2017 14:57:32 +0200")
Message-ID: <87efvvvd0t.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_134020_243218_D3030E84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> it seems like there was some discussion here and I wouldn't expect too many 
> more opinions ... do you think we can have a decision based on what has been 
> discussed here?

Well, there was an excellent reply from Steve and quite a few "in my
opinion this is safe" type of answers. [1] But bluntly said it does not
really matter what we (the engineers) think. What really matters here
are regulatory authorities' opinions and rulings. In that respect here
are few items I want to point out:

o I suspect that from someone's, who is not familiar with software
  engineering, point of view there is still quite a diffference from
  modifiying source code or just enabling few options from Kconfig with
  a custom regdb rule.

o I don't know about other countries, but in Finland applying for any
  type of license (even if just to a license to drive a moped) needs
  both time and money. So there is significant effort anyway needed to
  legally use this band. And how many users there really are is unclear.

o Also this is not about enabling or disabling channel 13, but about a
  public _safety_ band which makes me very uneasy.

So the way I see this is that the risks outweigh the benefits and that's
why I do not want to take these. Sorry.

[1] https://patchwork.kernel.org/patch/9641105/

-- 
Kalle Valo

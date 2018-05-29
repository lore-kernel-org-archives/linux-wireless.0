Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46626 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935459AbeE2OuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 10:50:24 -0400
Message-ID: <ec8456ec39ba3af2a56a5738e0e21c0b179df92c.camel@coelho.fi> (sfid-20180529_165055_208343_8B0A27E1)
From: Luca Coelho <luca@coelho.fi>
To: Jonathan <jadit2@gmail.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org,
        Hao Wei Tee <angelsl@in04.sg>
Date: Tue, 29 May 2018 17:50:18 +0300
In-Reply-To: <CADPGViGBfviaasvCLQWTXo4=R2Fx2BLfpm7b0Ws=aH0oKw9ckg@mail.gmail.com>
References: <20180529072517.30135-1-luca@coelho.fi>
         <87fu2a9au0.fsf@kamboji.qca.qualcomm.com>
         <CADPGViGBfviaasvCLQWTXo4=R2Fx2BLfpm7b0Ws=aH0oKw9ckg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: pcie: compare with number of IRQs requested
 for, not number of CPUs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(note: your previous email didn't reach the linux-wireless mailing
list, since it drops all html emails without notice).


On Tue, 2018-05-29 at 07:35 -0700, Jonathan wrote:
> Do you think this will land in a 4.17 RC version, or in 4.17
> official, or in a 4.17.1 subsequent release?

We will try to get it into 4.17.  We are currently in 4.17-rc7, so
there probably won't be another rc release for 4.17.

If it doesn't go in, then we will most likely get it in 4.17.1 (or
maybe 4.17.2, depends on Greg's schedule).

Again, we can't really promise anything, because the patch needs to be
accepts at our assumed times in the whole chain, and is out of our
control.

--
Cheers,
Luca.

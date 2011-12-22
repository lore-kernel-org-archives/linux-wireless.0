Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab1LVBrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 20:47:51 -0500
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable
 when moving between multiple APs)
From: wwguy <wey-yi.w.guy@intel.com>
To: Cheng Renquan <crquan@gmail.com>
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAH5vBdJ4-33z3FbOwVG1QRzfFOwFpz1wccbQNDXEC6-NhBa31A@mail.gmail.com>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
	 <1324424765.13074.281.camel@wwguy-huron>
	 <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
	 <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
	 <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
	 <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
	 <CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com>
	 <CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
	 <CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com>
	 <CA+icZUUhg91UAPMRGgXYAvo6wkr5ogb+vW8SsB28BeUP_6-g6w@mail.gmail.com>
	 <1324484074.13074.313.camel@wwguy-huron>
	 <CAH5vBdJ4-33z3FbOwVG1QRzfFOwFpz1wccbQNDXEC6-NhBa31A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 17:40:57 -0800
Message-ID: <1324518057.4755.4.camel@wwguy-ubuntu> (sfid-20111222_024755_904763_1F8B823E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Renquan,

On Wed, 2011-12-21 at 15:28 -0800, Cheng Renquan wrote:
> I cherry-picked these 3 patches on top to v3.2.0-rc6, and now it's working,
> Thank you all everyone's effort;
> 
> [archuser@archtop linux-git]$ git cherry-pick 123877b80
> [b46 55de35a] iwlwifi: do not set the sequence control bit is not needed
>  Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>  1 files changed, 4 insertions(+), 1 deletions(-)
> [archuser@archtop linux-git]$ git cherry-pick 81670a49184
> [b46 1b0b51d] iwlwifi: tx_sync only on PAN context
>  Author: Johannes Berg <johannes.berg@intel.com>
>  1 files changed, 6 insertions(+), 0 deletions(-)
> [archuser@archtop linux-git]$ git cherry-pick 78feb35b81
> [b46 73d79e2] iwlwifi: allow to switch to HT40 if not associated
>  Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
Thank you for the update, I am glad works for you
> 
> When walking to some corner meeting rooms (but still has good
> wifi connectivity, verified by another Android phone wifi ;),
> the roaming may be from previous AP to none and none to next AP,
> the process may need 1 to 2 minutes to be stable again, it's not
> ideally swift but acceptable,
> 
> 
Yes, I know we have more works to do on roaming, it is on our to-do list

Thanks
Wey
 
> Dec 21 14:59:11 archtop NetworkManager[2333]: <info> (wlan0): roamed
> from BSSID 24:B6:57:34:CC:5F (blizzard) to 6C:9C:ED:EC:BC:7F
> (blizzard)
> Dec 21 14:59:41 archtop NetworkManager[2333]: <info> (wlan0): roamed
> from BSSID 6C:9C:ED:EC:BC:7F (blizzard) to (none) ((none))
> Dec 21 14:59:53 archtop NetworkManager[2333]: <info> (wlan0): roamed
> from BSSID (none) ((none)) to 2C:3F:38:F6:A8:AF (blizzard)
> 
> 
> Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



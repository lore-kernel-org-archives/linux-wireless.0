Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59282 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1AGCeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:34:03 -0500
Received: by iyi12 with SMTP id 12so15421110iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:34:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19750.30510.548719.848168@gargle.gargle.HOWL>
References: <19749.32067.311517.479374@gargle.gargle.HOWL> <19749.37051.292861.996698@gargle.gargle.HOWL>
 <19750.24410.495583.789895@gargle.gargle.HOWL> <AANLkTintPXzmiGnjEQvXUO3hVCW9J4tGn=MookTx1qBM@mail.gmail.com>
 <AANLkTi=ZcigYLqqmhHc638_AxSODWrVrTV5KELRws3XX@mail.gmail.com> <19750.30510.548719.848168@gargle.gargle.HOWL>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Thu, 6 Jan 2011 18:33:42 -0800
Message-ID: <AANLkTimgd-EbLBe6KHnj5_9Paeg++rp1v8J5s5hy_NOa@mail.gmail.com>
Subject: Re: [RFC v2] cfg80211: Add HT BSS attributes
To: Sujith <m.sujith@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 6:15 PM, Sujith <m.sujith@gmail.com> wrote:
> Daniel Halperin wrote:
>> Yeah, me too.  Isn't greenfield mode (whether there are legacy devices
>> around) part of the operating capabilities and should be supported by
>> hostapd?
>
> Yes, hostapd does check if there are non-GF stations in the BSS and updates
> the HT operation mode parameters. But the nl80211 interface hook is currently
> not implemented.
>

right.. so don't we want this patch? :)  Sorry if I'm being obtuse

Dan

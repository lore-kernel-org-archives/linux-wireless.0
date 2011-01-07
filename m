Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36493 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab1AGCPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:15:36 -0500
Received: by gwj20 with SMTP id 20so7566208gwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:15:35 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19750.30510.548719.848168@gargle.gargle.HOWL>
Date: Fri, 7 Jan 2011 07:45:10 +0530
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2] cfg80211: Add HT BSS attributes
In-Reply-To: <AANLkTi=ZcigYLqqmhHc638_AxSODWrVrTV5KELRws3XX@mail.gmail.com>
References: <19749.32067.311517.479374@gargle.gargle.HOWL>
	<19749.37051.292861.996698@gargle.gargle.HOWL>
	<19750.24410.495583.789895@gargle.gargle.HOWL>
	<AANLkTintPXzmiGnjEQvXUO3hVCW9J4tGn=MookTx1qBM@mail.gmail.com>
	<AANLkTi=ZcigYLqqmhHc638_AxSODWrVrTV5KELRws3XX@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Halperin wrote:
> Yeah, me too.  Isn't greenfield mode (whether there are legacy devices
> around) part of the operating capabilities and should be supported by
> hostapd?

Yes, hostapd does check if there are non-GF stations in the BSS and updates
the HT operation mode parameters. But the nl80211 interface hook is currently
not implemented.

Sujith

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaBDMeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 07:34:07 -0500
Message-ID: <1391517243.4134.9.camel@jlt4.sipsolutions.net> (sfid-20140204_133410_916156_92DEBCFA)
Subject: Re: [RFC 0/2] cfg80211: add channel switching awareness
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 04 Feb 2014 13:34:03 +0100
In-Reply-To: <CA+BoTQ=xoqfyNurLibYTqptYq88uCT2Sna3dVPQue8Uw-XNWvg@mail.gmail.com> (sfid-20140204_132659_881004_05EC0336)
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 <1391431407.4488.9.camel@jlt4.sipsolutions.net>
	 <1391509638.26522.72.camel@porter.coelho.fi>
	 <CA+BoTQ=xoqfyNurLibYTqptYq88uCT2Sna3dVPQue8Uw-XNWvg@mail.gmail.com>
	 (sfid-20140204_132659_881004_05EC0336)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-04 at 13:26 +0100, Michal Kazior wrote:

> > I think mac80211 should keep the client CSA control and the userspace
> > should control the host interfaces.  cfg80211 should keep track of the
> > channel switches and be asked if the switch is okay (so it can take the
> > interface combinations and regulatory into consideration).
> 
> Why does mac80211 need to keep CSA control? Does it solve anything?

It makes more sense. You're too focused on ath10k. Think about ath6kl,
for example.

johannes


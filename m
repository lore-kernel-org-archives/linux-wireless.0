Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41302 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaKFMjq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 07:39:46 -0500
Message-ID: <1415277562.17015.4.camel@sipsolutions.net> (sfid-20141106_133949_605233_DCE96D07)
Subject: Re: [PATCH] mac80211: Fix regression that triggers a kernel BUG
 with CCMP
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ronald Wahl <ronald.wahl@raritan.com>,
	linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 06 Nov 2014 13:39:22 +0100
In-Reply-To: <545B6AD3.8020301@broadcom.com>
References: <1415267752-4704-1-git-send-email-ronald.wahl@raritan.com>
	 <1415268135.1884.1.camel@sipsolutions.net> <545B6AD3.8020301@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 13:34 +0100, Arend van Spriel wrote:
> On 06-11-14 11:02, Johannes Berg wrote:
> > Oh, regarding Cc stable - don't actually send the mail there if you can
> > help it.
> 
> What do you mean? Are you saying: It must be tagged, but 'git
> send-email' should not actually add the Cc field in the mail header.
> What is the story here? Guess I missed a memo ;-)

As far as I remember Greg just ignores the patches sent to the list and
picks them up when they hit Linus's tree instead (i.e. follows the
commit logs with like 'git log --grep "Cc: stable"') so there's no value
in actually sending out email, it's just noise.

So far it has worked for me, so I think it must be right :)

johannes


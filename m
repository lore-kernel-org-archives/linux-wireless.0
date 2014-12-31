Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:34107 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaLaOqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2014 09:46:20 -0500
Date: Wed, 31 Dec 2014 15:46:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Arend van Spriel <arend@broadcom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"egrumbach@gmail.com" <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
Message-ID: <20141231144617.GE6332@pd.tnic> (sfid-20141231_154636_404494_3832A21A)
References: <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
 <20141230212326.GA29263@pd.tnic>
 <54A328C2.5080606@lwfinger.net>
 <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
 <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
 <54A3D955.6020809@broadcom.com>
 <alpine.LNX.2.00.1412311408090.31609@pobox.suse.cz>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DD8D8@hasmsx107.ger.corp.intel.com>
 <54A3FECC.7050202@hurleysoftware.com>
 <CAGRGNgVMa=P9XbuFqfKHu5Gpiw=3h_OtOzSUYCsMbVLfTuL2Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGRGNgVMa=P9XbuFqfKHu5Gpiw=3h_OtOzSUYCsMbVLfTuL2Zw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 01, 2015 at 01:40:53AM +1100, Julian Calaby wrote:
> Sadly, nobody will read that. It needs to be at least an error,
> possibly with a big splat to scare people.
> 
> Maybe using one of WARN()'s siblings instead.

And that opens a lot of useless bugzillas...

The right thing to do is go talk to the maintainers of the userspace
tools or send patches.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

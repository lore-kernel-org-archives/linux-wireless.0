Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab2CZRNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 13:13:06 -0400
Date: Mon, 26 Mar 2012 12:13:01 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>
Subject: Re: brcmsmac still woes, possible regression?
Message-ID: <20120326171301.GC17126@thinkpad-t410> (sfid-20120326_191311_599954_BB08FE51)
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
 <4F6D939F.3030206@broadcom.com>
 <CAKprTDHSyh2Sv2wyY0hg4cjzWobV-zA4stY19-vB_hOBVAq5KQ@mail.gmail.com>
 <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com>
 <4F7035AD.1080503@broadcom.com>
 <20120326143232.GA17126@thinkpad-t410>
 <4F709F3E.1090405@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F709F3E.1090405@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 26, 2012 at 06:54:22PM +0200, Arend van Spriel wrote:
> I suspect the warning is caused because mac80211 flush callback is
> done after scanning on channels 12 and/or 13. I have a quick fix.
> The longer and preferred fix would be to cleanup channel.c and
> incorporate your regdom change. I plan to do that in separate
> patches.

At this point I think the regdom patch I sent is incomplete. We can do a
lot better. I'll follow up on the other thread a little later today with
my thoughts.

Seth

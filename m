Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:54944 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYJVWQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 18:16:33 -0400
From: Chr <chunkeey@web.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/3 v3] p54: more definitions form lmac_longbow.h and pda.h
Date: Thu, 23 Oct 2008 00:16:25 +0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200810170114.45742.chunkeey@web.de> <200810182318.01334.chunkeey@web.de> <20081022211856.GK15808@tuxdriver.com>
In-Reply-To: <20081022211856.GK15808@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810230016.25176.chunkeey@web.de> (sfid-20081023_001639_056416_C11F1A50)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 October 2008 23:18:56 John W. Linville wrote:
> On Sat, Oct 18, 2008 at 11:18:01PM +0200, Christian Lamparter wrote:
> > This patch ports more useful features to p54
> >   - PDR definitions for the synth chips & regulatory domain.
> >   - honour IEEE80211_TX_CTL_ASSIGN_SEQ flag, if it's set.
> >   - adds some lost mutex_lock & mutex_unlock.
> >   - replace two more "magic values" that sneaked past.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> 
> This doesn't seem to apply -- am I missing a patch?
> 
> John

Hmm, there's:
[PATCH] p54: enable 2.4/5GHz spectrum by eeprom bits.
[PATCH v2] p54: introduce new names for device firmwares
[PATCH] p54: implement MRR

if that doesn't help, I'll rebase the patches on the current wirless-testing.git
sometime on saturday(if this is ok!) as the patches could be conflicting with
the patches for the regression fixing.

Regards,
	Chr

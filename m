Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2HBNb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 09:31:26 -0400
Message-ID: <1343914280.4471.0.camel@jlt3.sipsolutions.net> (sfid-20120802_153129_916792_BE529147)
Subject: Re: [PATCH 1/2] cfg80211: add channel flag to prohibit OFDM
 operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Date: Thu, 02 Aug 2012 15:31:20 +0200
In-Reply-To: <20120802130431.GA32395@thinkpad-t410>
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
	 <1343854723-21987-2-git-send-email-seth.forshee@canonical.com>
	 <1343888660.4458.1.camel@jlt3.sipsolutions.net>
	 <20120802130431.GA32395@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-02 at 08:04 -0500, Seth Forshee wrote:
> On Thu, Aug 02, 2012 at 08:24:20AM +0200, Johannes Berg wrote:
> > On Wed, 2012-08-01 at 15:58 -0500, Seth Forshee wrote:
> > > Currently the only way for wireless drivers to tell whether or not OFDM
> > > is allowed on the current channel is to check the regulatory
> > > information. However, this requires hodling cfg80211_mutex, which is not
> > > visible to the drivers.
> > > 
> > > Other regulatory restrictions are provided as flags in the channel
> > > definition, so let's do similarly with OFDM. This patch adds a new flag,
> > > IEEE80211_CHAN_NO_OFDM, to tell drivers that OFDM on a channel is not
> > > allowed. This flag is set on any channels for which regulatory indicates
> > > that OFDM is prohibited.
> > 
> > Looks good, this needs to go into 3.6, right?
> 
> Yes, it should go into 3.6.

Alright, applied.

johannes


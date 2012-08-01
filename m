Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51611 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2HAVUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 17:20:34 -0400
Date: Wed, 1 Aug 2012 14:20:32 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Josh Boyer" <jwboyer@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH 1/2] cfg80211: add channel flag to prohibit OFDM operation
Message-ID: <20120801212032.GB10321@lenteja.do-not-panic.com> (sfid-20120801_232038_349898_F5542B2A)
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
 <1343854723-21987-2-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1343854723-21987-2-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 01, 2012 at 03:58:42PM -0500, Seth Forshee wrote:
> Currently the only way for wireless drivers to tell whether or not OFDM
> is allowed on the current channel is to check the regulatory
> information. However, this requires hodling cfg80211_mutex, which is not
> visible to the drivers.
> 
> Other regulatory restrictions are provided as flags in the channel
> definition, so let's do similarly with OFDM. This patch adds a new flag,
> IEEE80211_CHAN_NO_OFDM, to tell drivers that OFDM on a channel is not
> allowed. This flag is set on any channels for which regulatory indicates
> that OFDM is prohibited.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis

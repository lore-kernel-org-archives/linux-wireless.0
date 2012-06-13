Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56871 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2FMNqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:46:53 -0400
Date: Wed, 13 Jun 2012 08:46:51 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 7/9] brcm80211: smac: use mac80211 channel data for tx
 power limits
Message-ID: <20120613134651.GB3490@thinkpad-t410> (sfid-20120613_154656_987925_08FDF630)
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
 <1338906849-26135-8-git-send-email-seth.forshee@canonical.com>
 <4FD85FE3.3090604@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD85FE3.3090604@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 11:39:47AM +0200, Arend van Spriel wrote:
> On 06/05/2012 04:34 PM, Seth Forshee wrote:
> > Currently the limits from the internal X2 domain are used, regardless
> > of what regulatory rules are in effect. Instead use the power limits set
> > by the higher-level regulatory support.
> > 
> > The rules for the MIMO power limits are still always derived from the
> > world domain. Guidance from Broadcom is needed on how these limits
> > should be determined for other regulatory domains.
> 
> Have not got definite answer yet. Luis indicated that Qualcomm/Atheros
> had similar construct, but that is was not really needed and could be
> derived. I will have to follow up on it in a separate patch.

Thanks, that confirms my understanding of the state of things from
previous discussion.

Would you like me to modify that statement in some way? Or was your
comment purely informational? Reading it again, I probably will at least
add a comment to indicate that the state of things is workable for now
and will be improved later.


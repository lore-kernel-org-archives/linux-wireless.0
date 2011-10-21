Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3989 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab1JUOHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:07:37 -0400
Message-ID: <4EA17C9B.3070106@broadcom.com> (sfid-20111021_160805_002676_FACF173E)
Date: Fri, 21 Oct 2011 16:07:23 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Arend van Spriel" <arend@broadcom.com>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/17] fix mac80211 callback in brcmsmac and
 brcmfmac refactor
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2011 03:55 PM, Arend van Spriel wrote:
> Johannes Berg commented on our use of the start/stop callbacks in brcmsmac
> and we changed those callbacks. In rfkill testing it revealed a problem which
> has been fixed in this series as well.
> 
> The brcmfmac driver had some restructuring in preparation of USB support
> for new devices.
> 
> This patch series applies to the wireless-testing repository and depends on the
> series posted on Oct 18, 2011 with message id:
> 
> Message-ID: <1318939391-19495-1-git-send-email-arend@broadcom.com> 
> 

John,

I sent this series too quickly. Can you please drop this whole series. I
will resubmit a v2. Sorry for the disturbance.

Gr. AvS


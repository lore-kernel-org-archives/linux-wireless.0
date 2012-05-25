Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4135 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2EYWeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:34:10 -0400
Message-ID: <4FC008CE.4000405@broadcom.com> (sfid-20120526_003415_552326_34FD4917)
Date: Sat, 26 May 2012 00:33:50 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 6/8] brcm80211: smac: use mac80211 channel data
 for tx power limits
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-7-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-7-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> Currently the limits from the internal X2 domain are used, regardless
> of what regulatory rules are in effect. Instead use the power limits set
> by the higher-level regulatory support.
> 
> The rules for the MIMO power limits are still always derived from the
> world domain. Guidance from Broadcom is needed on how these limits
> should be determined for other regulatory domains.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

I still have the question on the mimo power limits pending. We can
address it later.

Gr. AvS



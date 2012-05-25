Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3712 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141Ab2EYWct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:32:49 -0400
Message-ID: <4FC00882.1070802@broadcom.com> (sfid-20120526_003252_208006_D8BC5EDC)
Date: Sat, 26 May 2012 00:32:34 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 2/8] brcm80211: smac: always set channel
 specified by mac80211
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-3-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-3-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> In some situations brcmsmac is choosing a channel internally. This makes
> it difficult at times to know what channel to use for enforcing
> regulatory constraints, so instead always use the channel from the
> mac80211 configuration.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

No comments here.

Gr. AvS



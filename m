Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3213 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab2EYWeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:34:10 -0400
Message-ID: <4FC008D6.6000007@broadcom.com> (sfid-20120526_003414_474283_D9ECD94B)
Date: Sat, 26 May 2012 00:33:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 7/8] brcm80211: smac: don't validate channels
 against internal regulatory data
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-8-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-8-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> The core regulatory support will disable channels not allowed by
> regulatory rules, so brcmsmac doesn't need to duplicate it.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

No comments.

Gr. AvS



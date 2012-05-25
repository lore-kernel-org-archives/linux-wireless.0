Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3712 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab2EYWc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 18:32:29 -0400
Message-ID: <4FC00871.8070703@broadcom.com> (sfid-20120526_003231_740239_F2532A59)
Date: Sat, 26 May 2012 00:32:17 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC PATCH 1/8] brcm80211: smac: don't set up tx power
 limits during initialization
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-2-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1334607462-5387-2-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:17 PM, Seth Forshee wrote:
> This code is unnecessary, and in fact it's never executed because the
> interface is never up when brcms_c_channels_commit() is called. Removing
> it helps simplify the implementation of proper regulatory support.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

No comments on this patch.

Gr. AvS


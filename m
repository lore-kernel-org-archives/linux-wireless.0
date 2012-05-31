Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3322 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2EaRuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 13:50:04 -0400
Message-ID: <4FC7AF38.3030309@broadcom.com> (sfid-20120531_195009_829631_48B9FFBC)
Date: Thu, 31 May 2012 19:49:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] brcm80211: smac: inform mac80211 of the X2
 regulatory domain
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
 <4FC008AB.4080107@broadcom.com> <20120526171800.GC11759@ubuntu-mba>
 <4FC21B3F.6090903@broadcom.com> <20120531144642.GB32179@thinkpad-t410>
In-Reply-To: <20120531144642.GB32179@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2012 04:46 PM, Seth Forshee wrote:
> So our options seem to be either calling ieee_hw_init() from
> brcms_c_attach() or breaking up brcms_c_attach() into two parts and
> calling ieee_hw_init() in the middle. Or else calling
> brcms_c_regd_init() from brcms_attach() as I have it now. What's your
> preference?

I am not in favor of breaking up the code for this. So leave it as you
have it now.

Gr. AvS


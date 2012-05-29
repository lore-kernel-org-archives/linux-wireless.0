Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3764 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab2E2QrE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 12:47:04 -0400
Message-ID: <4FC4FCD2.6070407@broadcom.com> (sfid-20120529_184709_682654_28D95133)
Date: Tue, 29 May 2012 18:44:02 +0200
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
 <4FC21B3F.6090903@broadcom.com> <20120529131212.GB28007@thinkpad-t410>
In-Reply-To: <20120529131212.GB28007@thinkpad-t410>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 03:12 PM, Seth Forshee wrote:
>> The hardware would need to signal the driver that a radar has been detected.
> Yes. I was trying to ask (not so clearly it turns out) whether or not
> Broadcom hardware can do this.

Sure.

> I note that if I boot into OS X then I can use the DFS channels with
> BCM43224. So obviously we should be able to use those frequencies. The
> question I'm trying to get an answer to is what's needed in the Linux
> driver to be in compliance. I'm planning to spend some time today
> reading to better understand DFS in 802.11

True. What I need to verify is whether the ucode for brcmsmac has DFS
enabled or not. I will let you know.

Gr. AvS


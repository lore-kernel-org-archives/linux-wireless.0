Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:39161 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760765AbYHFPlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 11:41:37 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1159950nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 08:41:34 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: Add module parameter to disable HW crypto
Date: Wed, 6 Aug 2008 18:06:39 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200808061727.32096.IvDoorn@gmail.com> <1218036145.23048.8.camel@johannes.berg>
In-Reply-To: <1218036145.23048.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808061806.40006.IvDoorn@gmail.com> (sfid-20080806_174152_915799_06FA4E31)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 August 2008, Johannes Berg wrote:
> On Wed, 2008-08-06 at 17:27 +0200, Ivo van Doorn wrote:
> > Add a module parameter to rt61 and rt73 to disable
> > HW crypto. The option should only be checked when
> > determining if the SUPPORT_HW_CRYPTO flag should
> > be set or not.
> 
> I wonder if instead mac80211 should have an option for this. It'd be
> trivial to simply not tell the hardware about the keys.

Then it probably needs to be a per physical interface configuration option,
which can only be toggled when the interface is down. Because I don't think
you want the option to be global for all available physical interfaces.

Ivo

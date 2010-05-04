Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50213 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab0EDTwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 15:52:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 12:52:12 -0700
Date: Tue, 4 May 2010 12:52:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Mathieu Olivari <Mathieu.Olivari@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211/ath9k: HT rates in Mesh
Message-ID: <20100504195211.GG2624@tux>
References: <93781E992CBA7843962D8B0E7D683F3C1116C465A6@SC1EXMB-MBCL.global.atheros.com>
 <20100504194348.GD2624@tux>
 <93781E992CBA7843962D8B0E7D683F3C1116C465EA@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <93781E992CBA7843962D8B0E7D683F3C1116C465EA@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc'ing linux-wireless.

On Tue, May 04, 2010 at 12:45:36PM -0700, Mathieu Olivari wrote:
> BTW, do you know if HT is supported in Mesh ?

This would involve doing the same as for IBSS that Benoit
is doing, someone with good will would have to do it. It should
be fairly easy to review the patches implemented by Benoit to
port to Mesh but there may be some unresolved things I may be
overlooking.

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0KVSBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:01:08 -0500
Subject: Re: Use case for the radiotap rate patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CEAAFB1.1020707@create-net.org>
References: <4CE8F8D9.1020201@create-net.org>
	 <1290440383.5718.2.camel@jlt3.sipsolutions.net>
	 <4CEAAFB1.1020707@create-net.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 10:01:04 -0800
Message-ID: <1290448864.5718.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-22 at 19:00 +0100, Roberto Riggio wrote:
> Il 22/11/2010 16:39, Johannes Berg ha scritto:
> > radiotap now has a way to specify one attribute multiple times, so that
> > should be used for MRR
> Is there a patch available for the linux kernel that supports this
> new approach to specify the MRR? I can easly modify the click
> radiotap header generation code, but without the support in
> the kernel it would be rather pointless.

The kernel parser will support this, but you'd have to provide the code
to actually use multiple rates as MRR

johannes


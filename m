Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1BNMIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 07:08:25 -0500
Subject: Re: [RFC/RFT] iwl3945: use software scanning by default
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1297172211-17448-1-git-send-email-sgruszka@redhat.com>
References: <1297172211-17448-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:08:19 +0100
Message-ID: <1297685299.3785.32.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 14:36 +0100, Stanislaw Gruszka wrote:
> Looking for some more testing and opinions.
> 
> Patch fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=671366
> and probably some other "very poor performance" bugs reported
> elsewhere.
> 
> Sometimes after hardware scanning device is unable to receive frames
> at higher rate, what cause that very slow speed is observed by the users.

Is there any more information about this problem?

My experience is limited to newer devices, but SW scan is typically not
really good because the device treats it as a disassoc/assoc. It may not
be as bad on 3945 as on newer devices though (where it's really not a
good idea due to dual-mode etc.)

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3HFNy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 09:54:29 -0400
Message-ID: <1375797260.8219.21.camel@jlt4.sipsolutions.net> (sfid-20130806_155444_142388_112F393B)
Subject: Re: linux-next: Tree for Aug 6 [ wireless | iwlwifi | mac80211 ? ]
From: Johannes Berg <johannes@sipsolutions.net>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	wireless <linux-wireless@vger.kernel.org>
Date: Tue, 06 Aug 2013 15:54:20 +0200
In-Reply-To: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com> (sfid-20130806_155146_826369_E50BB27F)
References: <CA+icZUX8OcTSOABO6Nbz5R6_5-m39rsYOpDqYBA7hf8LFvJLLA@mail.gmail.com>
	 (sfid-20130806_155146_826369_E50BB27F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-06 at 15:51 +0200, Sedat Dilek wrote:
> OK, I did not try with debugging enabled and/or w/o Network-Manager.
> 
> If you know of an issue, please let me know.

No, but the dmesg looks like security problems - check wpa_supplicant
log

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46889 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaAWTPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 14:15:32 -0500
Message-ID: <1390504524.4142.39.camel@jlt4.sipsolutions.net> (sfid-20140123_201538_888515_65F5621F)
Subject: Re: [PATCH v2] mac80211: send {ADD,DEL}BA on AC_VO like other mgmt
 frames, as per spec
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 23 Jan 2014 20:15:24 +0100
In-Reply-To: <1390503994-13496-1-git-send-email-karl.beldan@gmail.com> (sfid-20140123_200744_197087_64BEEC45)
References: <1390486106.4142.15.camel@jlt4.sipsolutions.net>
	 <1390503994-13496-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20140123_200744_197087_64BEEC45)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 20:06 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> ATM, {ADD,DEL}BA and BAR frames are sent on the AC matching the TID of
> the BA parameters. Johannes recalled [1] that it fixed some races with
> the DELBA and indeed this behavior was introduced in [2].

Applied. I made some minor edits to the commit log, notably to fix that
you had too many [2] (I guess originally you wanted to link to all the
different emails?)

johannes


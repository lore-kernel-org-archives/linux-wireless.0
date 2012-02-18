Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2BRNJp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 08:09:45 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE2202A.4080303@gmx.net> (sfid-20111209_155026_272581_C336F412)
References: <4EE2202A.4080303@gmx.net>
	 (sfid-20111209_155026_272581_C336F412)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Feb 2012 14:09:42 +0100
Message-ID: <1329570582.3443.5.camel@jlt3.sipsolutions.net> (sfid-20120218_140949_779575_5BB0DB68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-09 at 15:50 +0100, Wolfgang Breyha wrote:

> If I connect to this one and start eg. videostreaming it takes only a few
> minutes and my machine gets completly unstable. Various applications crash,
> sounds starts crackling, video gets artefacts. Also doing large downloads
> helps to kill various components. gnome-shell, firefox, ... looks like
> iwlwifi writes random memory.

Just to give this some public closure as we've been discussing this in
private for a while now -- the problem was caused by the AES-NI FPU
state corruption problem that's been discussed elsewhere for a while.

johannes


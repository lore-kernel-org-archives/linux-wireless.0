Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54546 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaAWTeK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:10 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so2061432wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 11:34:08 -0800 (PST)
Date: Thu, 23 Jan 2014 20:38:10 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH v2] mac80211: send {ADD,DEL}BA on AC_VO like other mgmt
 frames, as per spec
Message-ID: <20140123193809.GA22546@gobelin> (sfid-20140123_203415_392007_7A9D5E97)
References: <1390486106.4142.15.camel@jlt4.sipsolutions.net>
 <1390503994-13496-1-git-send-email-karl.beldan@gmail.com>
 <1390504524.4142.39.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1390504524.4142.39.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 23, 2014 at 08:15:24PM +0100, Johannes Berg wrote:
> On Thu, 2014-01-23 at 20:06 +0100, Karl Beldan wrote:
> > From: Karl Beldan <karl.beldan@rivierawaves.com>
> > 
> > ATM, {ADD,DEL}BA and BAR frames are sent on the AC matching the TID of
> > the BA parameters. Johannes recalled [1] that it fixed some races with
> > the DELBA and indeed this behavior was introduced in [2].
> 
> Applied. I made some minor edits to the commit log, notably to fix that
> you had too many [2] (I guess originally you wanted to link to all the
> different emails?)
> 
Yes, only the 2 first [2]s were intended [2]s .. in the very end of the
day I had to struggle to write this, I guess it shows.
 
Karl

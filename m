Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3018 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbXJQOiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:38:55 -0400
Date: Wed, 17 Oct 2007 10:04:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: make ieee802_11_parse_elems return void
Message-ID: <20071017140444.GA5744@tuxdriver.com> (sfid-20071017_153858_093635_675BE1C7)
References: <1192588723322-git-send-email-linville@tuxdriver.com> <1192608911.8841.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1192608911.8841.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17, 2007 at 10:15:11AM +0200, Johannes Berg wrote:
> On Tue, 2007-10-16 at 22:38 -0400, John W. Linville wrote:
> 
> Looks good to me, but
> 
> > -	/* Do not trigger error if left == 1 as Apple Airport base stations
> > -	 * send AssocResps that are one spurious byte too long. */
> > -
> > -	return unknown ? ParseUnknown : ParseOK;
> > +	return;
> 
> huh?

You don't like the bare return at the end?  Or are you questioning
something else?

John
-- 
John W. Linville
linville@tuxdriver.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:63100 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaAVNK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 08:10:28 -0500
Received: by mail-we0-f181.google.com with SMTP id u56so293904wes.40
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 05:10:27 -0800 (PST)
Date: Wed, 22 Jan 2014 14:09:24 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	helmut.schaa@googlemail.com
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
Message-ID: <20140122130924.GA18365@magnum.frso.rivierawaves.com> (sfid-20140122_141031_329512_4FD71279)
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
 <1390394079.4334.30.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1390394079.4334.30.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 01:34:39PM +0100, Johannes Berg wrote:
> Hmm. I guess you're right about the spec, but I vaguely remember races
> in this with the delBA going out too soon or so?
> 

Indeed, this was intended by cf6bb79 ("Use appropriate TID for sending
BAR, ADDBA and DELBA frames") and I overlooked it .. will look into it,
thanks.
I Cced Helmut who authored the said commit.
 
Karl

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaAWMHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:07:00 -0500
Message-ID: <1390478816.4142.10.camel@jlt4.sipsolutions.net> (sfid-20140123_130705_120999_149E6B85)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 23 Jan 2014 13:06:56 +0100
In-Reply-To: <CA+BoTQ=vACFk2_9xgUVdZKjrcfhNBswULG-5v7HC=Bsa3kLpVQ@mail.gmail.com> (sfid-20140123_073512_511528_7B5395E1)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
	 <CA+BoTQ=vACFk2_9xgUVdZKjrcfhNBswULG-5v7HC=Bsa3kLpVQ@mail.gmail.com>
	 (sfid-20140123_073512_511528_7B5395E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 07:35 +0100, Michal Kazior wrote:

> Also currently cfg80211 is oblivious to HT40+/HT40- and It doesn't
> consider HT40+ @ chan6 and HT40- @ chan6 as different channels, right?

Yes, this is a bug I've known about for a long time. I'll buy whoever
solves it a beer :)

johannes


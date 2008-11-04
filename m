Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:47329 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbYKDMnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 07:43:21 -0500
Received: by wf-out-1314.google.com with SMTP id 27so3175070wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 04:43:21 -0800 (PST)
Message-ID: <b6c5339f0811040443j68758507m7659339f8f6f4aa4@mail.gmail.com> (sfid-20081104_134325_995311_060615BD)
Date: Tue, 4 Nov 2008 07:43:21 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: No ProbeResp - assume out of range
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200811041217.51096.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	 <43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com>
	 <20081103002558.GA14153@tesla> <200811041217.51096.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2008 at 6:17 AM, Michael Buesch <mb@bu3sch.de> wrote:
> Well, so it seems this is caused by the driver honoring the filter flag for
> beacons. b43 and b43legacy do this, too. So they most likely have the same
> misbehaviour.
> In the end, I'd still call this a mac80211 bug. Why does mac80211 suppress
> beacons (by clearing the flag), if it needs them?

The patch in question disables all beacons, not just ones coming from
other bssid.

-- 
Bob Copeland %% www.bobcopeland.com

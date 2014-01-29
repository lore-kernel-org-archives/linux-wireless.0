Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaA2ISH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 03:18:07 -0500
Message-ID: <1390983472.4143.0.camel@jlt4.sipsolutions.net> (sfid-20140129_091810_913579_46656EB6)
Subject: Re: [PATCH v2 1/3] cfg80211: add helper reg_get_regdomain() function
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Janusz Dziedzic <janusz.dziedzi@tieto.com>
Date: Wed, 29 Jan 2014 09:17:52 +0100
In-Reply-To: <CAB=NE6VfmOMVT3zxE1iEOtT53SycgrrpiKuoi2NPuDXvccz96Q@mail.gmail.com> (sfid-20140128_204258_986741_2295FC10)
References: <1390394624-3927-1-git-send-email-janusz.dziedzic@tieto.com>
	 <20140125003418.GF28512@garbanzo.do-not-panic.com>
	 <CALhHN=p11A-kA3S=ESz85OUSfHr5t+Qqka24wwbvfJuA-bksXQ@mail.gmail.com>
	 <CAB=NE6VfmOMVT3zxE1iEOtT53SycgrrpiKuoi2NPuDXvccz96Q@mail.gmail.com>
	 (sfid-20140128_204258_986741_2295FC10)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-28 at 11:42 -0800, Luis R. Rodriguez wrote:

> > You mean we should introduce:
> > iw wlanX reg get?
> 
> Sure, and iw dev reg get can also display what it does now but then
> also iterate over all wiphys and also display all wiphy's own regd if
> they have any.

I'm not really sure I see much point in all this - what userspace
eventually cares about isn't the reg data but the channel list that can
be obtained with (the equivalent of) iw list.

johannes


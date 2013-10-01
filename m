Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48204 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3JAAnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 20:43:18 -0400
Message-ID: <a6a968ed9a6ea34fc3e0da4a548f8046.squirrel@www.codeaurora.org> (sfid-20131001_024322_411842_9B3DF8AD)
In-Reply-To: <20130926110934.GA5070@w1.fi>
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
    <20130926110934.GA5070@w1.fi>
Date: Tue, 1 Oct 2013 00:43:14 -0000
Subject: Re: [PATCH 0/2] nl80211/cfg80211: Support PMF on drivers with
 integrated AP SME
From: clanctot@codeaurora.org
To: "Jouni Malinen" <j@w1.fi>
Cc: "Chet Lanctot" <clanctot@codeaurora.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, Sep 17, 2013 at 12:31:34PM -0700, Chet Lanctot wrote:
>> These patches represent a small number of changes to the
>> nl80211/cfg80211 interface to support Protected Management Frames
>> (PMF, 802.11w) on an AP.  Specifically, these changes are needed for
>> drivers that have the AP SME integrated.
>>
>> Support is added for drivers that do not implement the SA Query
>> procedure
>> that is part of PMF.  Instead, the need for upper layer software to
>> do this procedure is advertised.  And support is added so that  whether
>> PMF should be used for station connections is communicated to the
>> driver.
>
> The patches here have some issues in not compiling and formatting
> (trailing whitespace) and as such, cannot be applied as-is. I'd expect a
> new version to be posted to address those issues.
>
> That said, if there is any feedback on the general direction used here,
> that would obviously be welcome even before the updated patches are
> posted.
>
> --
> Jouni Malinen                                            PGP id EFC895FA
>

Thank you Jouni for your comments.

You are correct, a new version of the patches will be sent out that
address the compiling and formatting issues.  I am also getting feedback
from others, and I will incorporate that feedback as well before sending
out the updated patches.

   - Chet Lanctot


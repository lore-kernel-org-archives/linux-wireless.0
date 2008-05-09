Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19868 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYEIH5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2008 03:57:39 -0400
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Helmut Schaa" <hschaa@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
References: <200805081030.57966.hschaa@suse.de>
	<200805081334.07599.hschaa@suse.de>
	<1210246602.3547.45.camel@johannes.berg>
	<1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 09 May 2008 10:56:34 +0300
In-Reply-To: <1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com> (ext Tomas Winkler's message of "Fri\, 9 May 2008 00\:45\:57 +0300")
Message-ID: <87ej8bykp9.fsf@nokia.com> (sfid-20080509_095648_808063_A4EED020)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

> On Thu, May 8, 2008 at 2:36 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2008-05-08 at 13:34 +0200, Helmut Schaa wrote:
>>  > Some APs refuse association if the supported rates contained in the
>>  > association request do not match its own supported rates. This patch
>>  > introduces a new function which builds the intersection between the AP's
>>  > supported rates and the client's supported rates to work around such
>>  > problems. The same approach is already used in ipw2200 for example.
>>  >
>>  > Signed-off-by: Helmut Schaa <hschaa@suse.de>
>>
>>  Thanks. Looks ok to me.
>
> Are we sure there is no  firmware with the fix for this AP?

Most probably this isn't the only AP which has a similar bug, so it's
better to add a workaround anyway. Let's just hope that it doesn't
create any regressions.

-- 
Kalle Valo

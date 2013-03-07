Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37748 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab3CGHMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 02:12:32 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Corey Richardson <corey@octayn.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: mac80211: regression: fd0f979 no long authenticates w/ath9k_htc
References: <CA++BO6QA9cFmM2kU4u8ASxWqJeGwUB1385awKfXLP=O0fA87NA@mail.gmail.com>
	<1362571344.8457.9.camel@jlt4.sipsolutions.net>
	<CA++BO6TciosdjiFaSAPvyCYsTU-J8UKCefPtxc8bcc04fnh9mQ@mail.gmail.com>
Date: Thu, 07 Mar 2013 09:12:30 +0200
In-Reply-To: <CA++BO6TciosdjiFaSAPvyCYsTU-J8UKCefPtxc8bcc04fnh9mQ@mail.gmail.com>
	(Corey Richardson's message of "Wed, 6 Mar 2013 18:36:53 -0500")
Message-ID: <877gljadk1.fsf@purkki.adurom.net> (sfid-20130307_081235_348346_60C87E19)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Corey Richardson <corey@octayn.net> writes:

> On Wed, Mar 6, 2013 at 7:02 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> Do you think you could run trace-cmd to capture what's going on before
>> and after?
>>
>
> What should I be recording? The NetworkManager process? I'm unfamiliar
> with ftrace.

You should use trace-cmd. Something like this:

trace-cmd record -e mac80211 -e cfg80211

And then send compressed trace.dat to Johannes. More info:

http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing

-- 
Kalle Valo

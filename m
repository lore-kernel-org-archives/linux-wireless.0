Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21556 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYLEJ7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 04:59:04 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v4 5/5] mac80211: track master queue status
References: <20081202200219.5507.83250.stgit@tikku>
	<20081202200426.5507.44042.stgit@tikku>
	<1228412076.5692.25.camel@johannes.berg> <87r64ni2yr.fsf@nokia.com>
	<1228470093.3970.8.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 05 Dec 2008 11:57:54 +0200
In-Reply-To: <1228470093.3970.8.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 05 Dec 2008 10\:41\:33 +0100")
Message-ID: <87ej0neyfx.fsf@nokia.com> (sfid-20081205_105909_833607_8A8D7A31)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2008-12-05 at 07:51 +0200, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > I wonder if we should optimise the spinlock here?
>> 
>> That would be nice, but how to do that?
>
> I only meant to lock/unlock it just once instead of for each possible
> queue.

Ah, of course, stupid of me. I'll fix that.

-- 
Kalle Valo

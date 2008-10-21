Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:60486 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYJUNlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 09:41:05 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2426961rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 06:41:04 -0700 (PDT)
Message-ID: <b6c5339f0810210641m14117f47k491e854c4746a3d7@mail.gmail.com> (sfid-20081021_154111_882339_D79828B4)
Date: Tue, 21 Oct 2008 09:41:04 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix a few typos in mac80211 kernel doc
Cc: linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1224571471.27899.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081021012027.GA25144@hash.localnet>
	 <1224571471.27899.69.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 2:44 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Thanks Bob, John, can you take this patch?
>
> Out of curiosity, what would you want from the book?

It's kind of hard to say.  I was mostly reading it to get the big picture
of mac80211's data structures, and for that purpose, what's already there
mostly sufficed.  There are obviously lots of TBD sections which could
use a fleshing out.

Right now, as the near-total noob that I am, I find reading the fine
source is the best way to understand everything.  I think driver writers
new to linux wireless could perhaps benefit from an overview of driver
responsibilities, calling contexts, object lifetimes, etc.  A lot of this
is already at the definition site of callbacks, but some stuff requires
digging.  A howto format in the introductory sections might be useful.

-- 
Bob Copeland %% www.bobcopeland.com

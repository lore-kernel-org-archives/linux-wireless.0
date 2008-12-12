Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:20257 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbYLLRhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 12:37:23 -0500
Received: by yx-out-2324.google.com with SMTP id 8so725291yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 09:37:22 -0800 (PST)
Message-ID: <b6c5339f0812120937y5f2c9323xd3f3c478d3b78525@mail.gmail.com> (sfid-20081212_183734_478432_7A96B84C)
Date: Fri, 12 Dec 2008 12:37:21 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "mohamed salim abbas" <mabbaswireless@gmail.com>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b3153e950812111500x27d3832avb99d84c13e601813@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226915999.3599.33.camel@johannes.berg>
	 <1226944799.3902.52.camel@johannes.berg>
	 <20081118194652.GD21772@tuxdriver.com>
	 <1ba2fa240811181508y633be12pd9f2f9bd0e2c81e4@mail.gmail.com>
	 <b3153e950812051553r2035b8aex4f54f6cf704a26b3@mail.gmail.com>
	 <1228554333.15939.0.camel@johannes.berg>
	 <b3153e950812062116q340c6b67l4d0c9a162d389cbf@mail.gmail.com>
	 <b6c5339f0812070619x19919c5dh62fe13085416145c@mail.gmail.com>
	 <b3153e950812072155t452aacb7p8ccefd1b2ec401ca@mail.gmail.com>
	 <b3153e950812111500x27d3832avb99d84c13e601813@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 6:00 PM, mohamed salim abbas
<mabbaswireless@gmail.com> wrote:
> I did try these patches out, I have a problem, sometime, when the
> card resume from suspend that I am currently tracing but still this
> patch does not bring me to the same state before the suspend.

Thanks for testing.  Yeah, it's still a work in progress.  I plan to
spend the weekend hacking on this and getting it into shape.

-- 
Bob Copeland %% www.bobcopeland.com

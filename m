Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:43016 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYFXL2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 07:28:35 -0400
Received: by rv-out-0506.google.com with SMTP id k40so7614040rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 04:28:34 -0700 (PDT)
Message-ID: <1ba2fa240806240428l66766eddtf960e22be00d2574@mail.gmail.com> (sfid-20080624_132838_671677_3857A21A)
Date: Tue, 24 Jun 2008 14:28:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <200806241308.09404.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <200806241242.11727.mb@bu3sch.de>
	 <1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
	 <200806241308.09404.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 2:08 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 24 June 2008 12:54:25 Tomas Winkler wrote:
>> See the log message...(known issue). Currently you have to loop over
>> rates to get this info. I wasn't sure if they are any b-only NICs
>> under mac80211 so I didn't run to implement it.
>
> b43legacy.
> I'd say we either implement it correctly or not at all.
> Everything else will only confuse users and generate useless noise
> on the lists.

Fair enough, I will resend the patch.

Tomas

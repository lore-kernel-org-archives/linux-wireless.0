Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:53888 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbYIHXch (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 19:32:37 -0400
Received: by yx-out-2324.google.com with SMTP id 8so961590yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 16:32:36 -0700 (PDT)
Message-ID: <1ba2fa240809081632j6816f059s30cc3b4ea5dcc2ed@mail.gmail.com> (sfid-20080909_013257_427151_3BFFA28D)
Date: Tue, 9 Sep 2008 02:32:35 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Matthew Garrett" <mjg@redhat.com>
Subject: Re: [PATCH 4/4] mac80211: stop queues before carrier off
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080908222859.GA6153@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080908153336.891710000@sipsolutions.net>
	 <20080908153510.167807000@sipsolutions.net>
	 <1ba2fa240809081440o2c88eaa7o1e120fe75c018b9e@mail.gmail.com>
	 <1220910240.9427.10.camel@localhost.localdomain>
	 <1ba2fa240809081508jd762ac6q9d8505879711d151@mail.gmail.com>
	 <20080908222859.GA6153@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 1:29 AM, Matthew Garrett <mjg@redhat.com> wrote:
> On Tue, Sep 09, 2008 at 01:08:17AM +0300, Tomas Winkler wrote:
>> It has to be other way around.
>
> [Citation needed]\

This is how any other connection manager I know works. Maybe I'm
trapped in old concepts but I don't find current NM paradigm
friendly.
Tomas

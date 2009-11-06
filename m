Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44847 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZKFR3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 12:29:01 -0500
Received: by ewy28 with SMTP id 28so1370481ewy.18
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 09:29:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890911060857l6e383578nc1c7d0f2ba63529f@mail.gmail.com>
References: <43e72e890911060857l6e383578nc1c7d0f2ba63529f@mail.gmail.com>
Date: Fri, 6 Nov 2009 12:29:05 -0500
Message-ID: <b6c5339f0911060929w78d16192o6c48e432e8e8c830@mail.gmail.com>
Subject: Re: Changing the way we handle region codes on Linux (public thread)
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Vivek Natarajan <vivek.natraj@gmail.com>,
	Jeffrey Baker <jwbaker@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Quan <David.Quan@atheros.com>,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 11:57 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> I think that sums it up.

I personally still like the idea of pushing the vendor-specific
codes out to user space and having psuedo-country codes for
those (e.g. "ATH_37").  Then the driver doesn't need all of the
static rules loaded all the time and it would drop a lot of
policy code from the driver.  CRDA could be enhanced to load
multiple databases, one for pure iso-3166 codes, one with
Atheros codes, one with Intel, etc.

-- 
Bob Copeland %% www.bobcopeland.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:44007 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZAFS53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 13:57:29 -0500
Received: by yx-out-2324.google.com with SMTP id 8so2530353yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 10:57:28 -0800 (PST)
Message-ID: <43e72e890901061057g106dead2wad00d2664874152d@mail.gmail.com> (sfid-20090106_195733_820392_479C1281)
Date: Tue, 6 Jan 2009 10:57:28 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] Fixed BSSID step 1: Disallow to set multicast BSSID
Cc: "Alina Friedrichsen" <x-alina@gmx.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1231267148.3654.15.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20090106014135.302730@gmx.net> <1231247805.3503.13.camel@johannes>
	 <20090106183543.241290@gmx.net> <1231267148.3654.15.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2009 at 10:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2009-01-06 at 19:35 +0100, Alina Friedrichsen wrote:

>> Is there somewhere a git repository, with all the new patches merged?
>> So that I have link where other people can download easily the newest
>> version and test it, to maybe look for other problem in the ad hoc
>> mode, before it is in compat-wireless.
>
> well, wireless-testing, but compat-wireless is updated nightly, iirc.

Affirmative.

Alina, check this guide out, it may help you to post your patches:

http://wireless.kernel.org/en/developers/Documentation/git-guide

  Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57838 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYA1OAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 09:00:24 -0500
Message-ID: <479DDC44.4050600@trash.net> (sfid-20080128_140028_923008_8BB1D31C)
Date: Mon, 28 Jan 2008 14:44:36 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, yi.zhu@intel.com
Subject: Re: [RFC PATCH 06/10] mac80211: A-MPDU Tx adding qdisc support
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>	 <11999857503421-git-send-email-ron.rindjunsky@intel.com>	 <479CC590.7090406@trash.net> <1ba2fa240801271119m29a316eeib815facfbf2051e0@mail.gmail.com>
In-Reply-To: <1ba2fa240801271119m29a316eeib815facfbf2051e0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Jan 27, 2008 7:55 PM, Patrick McHardy <kaber@trash.net> wrote:
>
>> Is there a reason to add new features to this instead of using
>> the generic multiqueue support, moving classification to a
>> classifier and killing wme?
>>
> Multiqueue is where we are heading to. We have developed this solution
> before multiqueue was accepted and it worked well for few months
> already so it can provide enough usability for 11n users for now.
> We still have too many opens to close so we prefer to stage them
> rather then choke on them. It will take few more weeks till we start
> to work on it unless someone else take the lead of course.


Thanks for the explanation.

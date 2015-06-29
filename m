Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36487 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbF2HlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 03:41:10 -0400
Received: by obzt3 with SMTP id t3so8507307obz.3
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2015 00:41:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435562850.2156.4.camel@sipsolutions.net>
References: <1435549847-18680-1-git-send-email-yeohchunyeow@gmail.com>
	<1435562850.2156.4.camel@sipsolutions.net>
Date: Mon, 29 Jun 2015 15:41:09 +0800
Message-ID: <CAEFj987fG9NrxWUfqtf3UVD8uWzAB-TeYAJvTDDoyH0JxUHKhA@mail.gmail.com> (sfid-20150629_094113_927026_4177E6D1)
Subject: Re: [PATCH] mac80211: remove compilation warning on mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 29, 2015 at 3:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2015-06-29 at 11:50 +0800, Chun-Yeow Yeoh wrote:
>> Remove the warning on the following:
>> mesh_hwmp.c: warning: ‘target_metric’ may be used
>> uninitialized in this function [-Wmaybe-uninitialized]
>>
> I don't see any such warning, and would prefer not to have a blanket
> initialization that might in the future suppress a valid warning.
>

Ok, noted.

FYI, I have compiled backports-20150626 and observed this warning.

----
Chun-Yeow

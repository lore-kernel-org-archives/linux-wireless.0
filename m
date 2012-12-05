Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2LELlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 06:41:42 -0500
Message-ID: <1354707724.9972.10.camel@jlt4.sipsolutions.net> (sfid-20121205_124145_791767_E133B9FB)
Subject: Re: [PATCH] mac80211: fixing the warning storm for budding chipsets
 without ampdu_action defined
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 05 Dec 2012 12:42:04 +0100
In-Reply-To: <CABPxzYKwA99yXhVR52L1UD=EGNNCotuR94d5pjfhOpnUj_G1DA@mail.gmail.com> (sfid-20121205_120742_596481_230C989A)
References: <CABPxzYKrYPo9S-t6dSPS3qgwKcsaD=uoiAm2+naS7C6D=3KBOg@mail.gmail.com>
	 <1354699072.9972.7.camel@jlt4.sipsolutions.net>
	 <CABPxzYKwA99yXhVR52L1UD=EGNNCotuR94d5pjfhOpnUj_G1DA@mail.gmail.com>
	 (sfid-20121205_120742_596481_230C989A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-05 at 16:37 +0530, Krishna Chaitanya wrote:
> I have verified the patch with the checkpatch.pl, i think the
> whitespace got introduced when i copied the patch from the file to
> mail.
> The Mail editor (gmail/thunderbird) automatically converts all tabs to spaces.
> 
> What should be the ideal settings for VIM editor and lets say gmail/thunderbird.
> 
> for VIM i have done:
> 
> set tabstop=4
> set shiftwidth=4
> set expandtab
> 
> Is there any thing extra i need to do? a little newbie help would be great :-)

There's some information on Thunderbird here:
http://www.kernel.org/doc/Documentation/email-clients.txt

I don't use it myself so don't really know if it's accurate.

johannes


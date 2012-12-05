Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:32914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2LEOEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:04:36 -0500
Date: Wed, 5 Dec 2012 08:04:31 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fixing the warning storm for budding chipsets
 without ampdu_action defined
Message-ID: <20121205140431.GA31677@thinkpad-t410> (sfid-20121205_150439_628404_FC58AF15)
References: <CABPxzYKrYPo9S-t6dSPS3qgwKcsaD=uoiAm2+naS7C6D=3KBOg@mail.gmail.com>
 <1354699072.9972.7.camel@jlt4.sipsolutions.net>
 <CABPxzYKwA99yXhVR52L1UD=EGNNCotuR94d5pjfhOpnUj_G1DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABPxzYKwA99yXhVR52L1UD=EGNNCotuR94d5pjfhOpnUj_G1DA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 05, 2012 at 04:37:19PM +0530, Krishna Chaitanya wrote:
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

That's not correct for editing kernel source. You should have:

 set tapstop=8
 set shiftwidth=8
 set noexpandtab

Seth


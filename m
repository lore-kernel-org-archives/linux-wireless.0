Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:48612 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3KXREm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 12:04:42 -0500
Received: by mail-we0-f176.google.com with SMTP id t61so2891602wes.21
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 09:04:40 -0800 (PST)
Message-ID: <529231A4.5010503@gmail.com> (sfid-20131124_180445_246118_BF8D453D)
Date: Sun, 24 Nov 2013 19:04:36 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2013-11-19
References: <528BCEDB.8010703@gmail.com>
In-Reply-To: <528BCEDB.8010703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/19/2013 10:49 PM, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request for 3.13.
> 
> I have here a few fixes for BT Coex. One of them is a NULL pointer
> dereference. Another one avoids to enable a feature that can make the
> firmware unhappy since the firmware isn't ready for it yet. WE also
> avoid a WARNING that can be triggered upon association in not-so-bad
> cases even if the association succeeded. We add support for new NICs
> (not yet on the market) and bump the API so that 3.13 will be able to
> work with the new firmware that will be out soon hopefully.
> I also have a boundary check from Johannes.
> 
> I reset my tree to wireless/master as the time of this writing. I did
> that mainly because I needed the changes that were in -next before 3.12
> went out even if 3.13-rc1 isn't out yet. I plan to rebase my tree on
> 3.13-rc2 (or 3.13-rc1 if this pull request makes it to 3.13-rc1 but that
> seems unlikely).
> Tell me if you have any issues.
> 
> 

FWIW - since 3.13-rc1 is already out and you haven't pulled yet, I
rebased this pull request --onto v3.13-rc1.

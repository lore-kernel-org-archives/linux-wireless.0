Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34587 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbbLHNVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 08:21:36 -0500
Received: by igvg19 with SMTP id g19so101094209igv.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2015 05:21:36 -0800 (PST)
Date: Tue, 8 Dec 2015 08:21:31 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing rebased, new HEAD commit
 f5feec4244464225c03ccc9ddad615cb43a044cc
Message-ID: <20151208132131.GA12251@localhost> (sfid-20151208_142353_076433_68F8F80A)
References: <87fuzkf2ef.fsf@kamboji.qca.qualcomm.com>
 <20151207193910.GB27529@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151207193910.GB27529@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 07, 2015 at 02:39:11PM -0500, John W. Linville wrote:
> All,
> 
> An earlier pull got a version of mac80211.git that was later reverted.
> Unfortunately, the intervening merges got things so screwed-up I
> couldn't reasonably unravel them.  So, I have taken the somewhat
> unusual step of rebasing wireless-testing here in the middle of the
> 4.4 stream.

For this reason, we are considering making the new wireless-testing
rebase the feeder trees for each build instead of once per cycle,
similarly to how linux-next is built.  For most users, the main
difference will behaving to remember to 'git pull --rebase' instead of
just 'git pull'.

If there are users that rely on the merging-type workflow, could you
weigh in on whether that is a strong requirement?

I'm running this in test-pilot mode now at its eventual home; comments
welcome:

https://git.kernel.org/cgit/linux/kernel/git/wireless/wireless-testing.git

-- 
Bob Copeland %% http://bobcopeland.com/

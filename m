Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab3AKKwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 05:52:19 -0500
Message-ID: <1357901563.9767.1.camel@jlt4.sipsolutions.net> (sfid-20130111_115222_172104_B229DAB4)
Subject: Re: [PATCH] mwifiex: change is_suspended variable type to atomic_t
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 11 Jan 2013 11:52:43 +0100
In-Reply-To: <1357880244-14610-1-git-send-email-bzhao@marvell.com> (sfid-20130111_060013_448876_78450B81)
References: <1357880244-14610-1-git-send-email-bzhao@marvell.com>
	 (sfid-20130111_060013_448876_78450B81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-10 at 20:57 -0800, Bing Zhao wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> is_suspended flag can be accessed by multiple threads.
> Use atomic variable type for is_suspended to ensure that there
> are no undefined behaviours.

atomic_t doesn't do what you seem to think it does, this patch is
completely bogus.

johannes


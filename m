Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab0JOUHT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 16:07:19 -0400
Message-ID: <4CB8B462.2080108@kernel.org>
Date: Fri, 15 Oct 2010 22:06:58 +0200
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly
 instead of depending on flush_scheduled_work()
References: <4CB874C0.8090003@kernel.org> <20101015192645.GA2438@tuxdriver.com> <4CB8AC80.7090802@kernel.org> <201010152207.31553.chunkeey@googlemail.com>
In-Reply-To: <201010152207.31553.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 10/15/2010 10:07 PM, Christian Lamparter wrote:
> Oh, so the "[PATCH v2.6.36-rc7]" in the patch subject was just "misleading" me.

Ah, sorry about that.  I usually tag them with the version tag the
patch was generated against, not the target version.  Now that I think
about it, it could definitely be confusing.  I'll try to be clearer.

Thanks.

-- 
tejun

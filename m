Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58256 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757594AbZJHWqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 18:46:43 -0400
Date: Thu, 8 Oct 2009 18:31:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] b43: Fix locking problem when stopping rfkill polling
Message-ID: <20091008223130.GA2798@tuxdriver.com>
References: <4accae5d.BgSJpcmlvg+W5PGM%Larry.Finger@lwfinger.net> <20091007190106.GB22394@tuxdriver.com> <4ACE4A48.9070901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ACE4A48.9070901@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 08, 2009 at 03:23:36PM -0500, Larry Finger wrote:
> On 10/07/2009 02:01 PM, John W. Linville wrote:
>> OK, but why do we start polling under the lock but stop polling without
>> the lock?  Should we start polling without holding the lock too?
>
> I see that this patch was committed. I hope that you will be sending it 
> upstream for 2.6.32. The correct version has been sent to stable for 
> inclusion in 2.6.31, but as usual, a mainline commit ID will be needed.

I've folded this into "b43: Fix PPC crash in rfkill polling on unload"
for sending upstream.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

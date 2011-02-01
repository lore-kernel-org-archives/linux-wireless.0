Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38833 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1BARpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 12:45:16 -0500
Date: Tue, 1 Feb 2011 12:32:47 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Review of moving all DFS parameters to userspace
Message-ID: <20110201173247.GE2560@tuxdriver.com>
References: <AANLkTimSV7rHhdjWqfV5ujW6dd==BusmeC8fJOXGxfaT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimSV7rHhdjWqfV5ujW6dd==BusmeC8fJOXGxfaT@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 01, 2011 at 08:38:05AM -0800, Luis R. Rodriguez wrote:
> I though we had reviewed the possibility of moving DFS parameters to
> userspace but it seems that's not the case. We now at least know we
> can keep the DFS regions: US, JP, ETSI, the next step is to determine
> if the DFS parameters for these regions will come from userspace or
> kernelspace. I'm inclined to support starting off with moving this to
> kernelspace just to let us move forward with this support, and once in
> kernel, review the possibility to move this out to userspace.
> 
> Thoughts?

Seems like a reasonable approach for the short term...better than
locking-in userland ABI...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

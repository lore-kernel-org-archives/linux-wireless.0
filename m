Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38999 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423264AbXBHTqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Feb 2007 14:46:33 -0500
Date: Thu, 8 Feb 2007 20:46:32 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "Jon Smirl" <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: use default flags on virtual interfaces
Message-ID: <20070208204632.1b4039b0@griffin.suse.cz>
In-Reply-To: <200702081401.39530.flamingice@sourmilk.net>
References: <9e4733910702061846y3117ff20g9bf234b25cb91116@mail.gmail.com>
	<200702081401.39530.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 8 Feb 2007 14:01:35 -0500, Michael Wu wrote:
> There is no need to set dev->flags on virtual interfaces
> during registration.

Applied to my tree, thanks to both Jon and Michael for fixing this.

 Jiri

-- 
Jiri Benc
SUSE Labs

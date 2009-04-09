Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33879 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313AbZDISpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 14:45:50 -0400
Date: Thu, 9 Apr 2009 14:34:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: sony-laptop still using rfkill's user_claim_unsupported
Message-ID: <20090409183454.GJ3349@tuxdriver.com> (sfid-20090409_204556_274615_8BB7BDCF)
References: <1239301678.4684.39.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239301678.4684.39.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 09, 2009 at 11:27:58AM -0700, reinette chatre wrote:
> Hi Johannes and John,
> 
> I found this issue with sony-laptop when trying to compile. This patch
> gets me compiling again but I do not know which avenue it should take as
> this rfkill cleanup work is not in Linus's tree yet. What do you
> suggest?
> 
> Thank you
> 
> Reinette

I'll take it.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

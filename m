Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4065 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbYC1CuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 22:50:15 -0400
Date: Thu, 27 Mar 2008 22:33:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: TKIP patches
Message-ID: <20080328023336.GA10006@tuxdriver.com> (sfid-20080328_025020_004121_FF23E8F7)
References: <1ba2fa240803271823m4adecaeat9ad05ee6bb97969b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240803271823m4adecaeat9ad05ee6bb97969b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2008 at 03:23:28AM +0200, Tomas Winkler wrote:
> John, what restraining you from applying TKIP patches to wireless-testing
> First of all they were acked by Johannes second they need to got into
> wider use, most of  the people don't pick up code from the mailing
> list but from git directory.
> Even TKIP is stupid encryption schema and everybody wants see it dead
> it's still used. From our testing our patches reduces significantly
> cpu utilization and throughput.
> If there are any other issues please let us know

The only TKIP-related patches I have in my queue that haven't been
applied are some cleanups from Harvey Harrison.  What other patches
do you mean?  The ones from a week or so ago have already been applied.

John
-- 
John W. Linville
linville@tuxdriver.com

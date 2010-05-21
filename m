Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab0EUSaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 14:30:20 -0400
Date: Fri, 21 May 2010 14:23:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/2] iwlwifi fixes for 2.6.34
Message-ID: <20100521182325.GA2495@tuxdriver.com>
References: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1273787385-9248-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 02:49:43PM -0700, Reinette Chatre wrote:
> We include two late fixes hoping to make it into 2.6.34.
> 
> "iwlwifi: fix internal scan race" fixes a kernel crash caused by
> accessing a NULL pointer. More can be read in
> https://bugzilla.kernel.org/show_bug.cgi?id=15824
> 
> "iwlagn: work around rate scaling reset delay" is already in
> wireless-next-2.6 but has since been shown to be an issue in 2.6.34 also.
> This fixes spurious firmware restarts that has been documented in
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2173 , but it is the
> community report tracked in
> https://bugzilla.kernel.org/show_bug.cgi?id=15782 that prompted us sending
> this fix to wireless-2.6 also.
> 
> These patches are also available from wireless-2.6 branch on
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
> Reinette Chatre (2):
>   iwlwifi: fix internal scan race
>   iwlagn: work around rate scaling reset delay

Since the one of these is already in linux-2.6 now, I'll just apply
the other one directly rather than pulling.  I hope that isn't too
inconvenient!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

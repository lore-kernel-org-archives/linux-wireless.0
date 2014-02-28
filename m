Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33018 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaB1SpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 13:45:14 -0500
Date: Fri, 28 Feb 2014 13:42:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: pull request: iwlwifi 2014-02-27
Message-ID: <20140228184225.GG30876@tuxdriver.com> (sfid-20140228_194521_994727_BB5E182C)
References: <530EE0EA.5030105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530EE0EA.5030105@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 27, 2014 at 08:53:30AM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> I have two fixes for 3.14.
> Johannes fixes a long standing bug in the AMPDU status reporting.
> Max fixes the listen time which was way too long and causes trouble to several APs.
> 
> Please pull - thanks
> 
>   emmanuel
> 
> The following changes since commit ec6f678c74dbdb06a6a775bbb00f1d26c17c404b:
> 
>   iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails (2014-02-20 19:16:27 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git master
> 
> for you to fetch changes up to d8105a24fce48b7b016e868923000871f4196e63:
> 
>   iwlwifi: mvm: fix TX status for aggregated packets (2014-02-27 08:50:32 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

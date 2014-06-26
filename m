Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41178 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910AbaFZRpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 13:45:17 -0400
Date: Thu, 26 Jun 2014 13:35:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath-current 20140626
Message-ID: <20140626173553.GA4733@tuxdriver.com> (sfid-20140626_194527_995286_27BE4058)
References: <878uojzrix.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878uojzrix.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2014 at 05:15:02PM +0300, Kalle Valo wrote:
> Hi John,
> 
> here's a pull request with two ath10k patches I would like to get into
> 3.16. Both of the changes are small and pretty safe. Change log:
> 
> Bartosz fixed an issue where we were not able to create 8 vdevs when
> using DFS. Michal removed a false warning which was just confusing
> people.
> 
> The following changes since commit a715c7ddd65a1a3b2839b8ebd759bb2d361f7675:
> 
>   wil6210: improve debug for WMI receive (2014-05-30 13:49:34 -0400)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git ath-current
> 
> for you to fetch changes up to dfa413de1e4388818f7dcdce0a90d6212e74895b:
> 
>   ath10k: fix 8th virtual AP interface with DFS (2014-06-02 21:44:53 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44568 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbaCNSaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 14:30:20 -0400
Date: Fri, 14 Mar 2014 14:28:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140311
Message-ID: <20140314182749.GB20339@tuxdriver.com> (sfid-20140314_193039_382208_E068FB8F)
References: <87y50hgghr.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y50hgghr.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2014 at 12:46:24PM +0200, Kalle Valo wrote:
> Hi John,
> 
> here's a new pull request from me, but just ath10k patches this time.
> Summary of the changes:
> 
> Michal now did some optimisations and was able to improve throughput by
> 100 Mbps on our MIPS based AP135 platform. Chun-Yeow added some
> workarounds to be able to better use ad-hoc mode. Ben improved log
> messages and added support for MSDU chaining. And, as usual, also some
> smaller fixes.
> 
> Please let me know if there are any problems.
> 
> Kalle
> 
> The following changes since commit ef1b4141d0430583743a6045901e4d1a73557a33:
> 
>   ath5k: set SURVEY_INFO_IN_USE on get_survey (2014-02-24 15:38:39 -0500)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 70dd77b4c50da518b57b8b9b125a8c9aabe9bc1a:
> 
>   ath10k: do not overwrite max_antenna_gain (2014-03-07 10:14:10 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

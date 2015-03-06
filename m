Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41979 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbbCFQbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 11:31:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2015-03-05
References: <1425558068.22928.3.camel@egrumbacBox>
Date: Fri, 06 Mar 2015 18:31:37 +0200
In-Reply-To: <1425558068.22928.3.camel@egrumbacBox> (Emmanuel Grumbach's
	message of "Thu, 5 Mar 2015 12:21:08 +0000")
Message-ID: <878ufa2il2.fsf@kamboji.qca.qualcomm.com> (sfid-20150306_173147_289074_21B85278)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com> writes:

> Hi Kalle,
>
> This is a pull request for 4.0. Details in the tag as usual.
> Thanks!
>
> The following changes since commit f5af19d10d151c5a2afae3306578f485c244db25:
>
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2015-02-17 17:41:19 -0800)
>
> are available in the git repository at:
>
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2015-03-05
>
> for you to fetch changes up to 4cd4b50cc2429294c23a1998c33fdfd804db0f37:
>
>   iwlwifi: mvm: BT Coex - fix a NULL pointer exception (2015-03-05 14:13:20 +0200)
>
> ----------------------------------------------------------------
> * fix ROC removal - avoids a firmware crash
> * fix throughput regression on iwldvm devices
> * fix panic in BT Coex
> * fixes in rate control
> * fixes in scan
>
> ----------------------------------------------------------------

Thanks, pulled.

-- 
Kalle Valo

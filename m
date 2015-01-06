Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:33610 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbAFRaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 12:30:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Dor Shaish <dor.shaish@intel.com>
Subject: Re: [PATCH 03/33] Revert "iwlwifi: use correct fw file in 8000 b-step"
References: <1419948357.21410.4.camel@egrumbacBox>
	<1419949148-24046-3-git-send-email-emmanuel.grumbach@intel.com>
Date: Tue, 06 Jan 2015 19:30:07 +0200
In-Reply-To: <1419949148-24046-3-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Tue, 30 Dec 2014 16:18:38 +0200")
Message-ID: <87wq4zzujk.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_183023_788134_B11742CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> From: Dor Shaish <dor.shaish@intel.com>
>
> Signed-off-by: Dor Shaish <dor.shaish@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In the future please document why you are reverting something. Now you
just leave people guessing the reason.

-- 
Kalle Valo

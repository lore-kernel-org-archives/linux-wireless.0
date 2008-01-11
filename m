Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:47214 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750872AbYAKFYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 00:24:16 -0500
Date: Fri, 11 Jan 2008 06:20:04 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: mabbas <mabbas@linux.intel.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [PATCH 5/5] iwlwifi: iwl3945 switch private
 workqueue to ieee80211->workqueue
Message-ID: <20080111062004.7364663d@morte> (sfid-20080111_052419_487941_6402A80A)
In-Reply-To: <47869DD0.5080803@linux.intel.com>
References: <1199876594889-git-send-email-joonwpark81@gmail.com>
	<47869DD0.5080803@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 10 Jan 2008 14:36:00 -0800
mabbas <mabbas@linux.intel.com> wrote:

> mac80211 workqueue used by mac80211 main background tasks. If we
> are going to share this with mac80211 then drivers queues
> need to be very efficient. In our workqueue we do sleep and
> that might affect mac80211 works.

I think that somebody (including me) already kindly asked you to avoid
top-quoting and - if possible - avoid to entirely quote a patch if there's
no need for it.

I understand that this is difficult to achieve, but tell me what MUA you
use, and I'll provide you with a patch.


--
Ciao
Stefano

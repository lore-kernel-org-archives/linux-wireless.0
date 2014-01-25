Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65437 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaAYAVm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:21:42 -0500
Received: by mail-pa0-f50.google.com with SMTP id kp14so3848662pab.37
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 16:21:42 -0800 (PST)
Date: Fri, 24 Jan 2014 16:21:36 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v2 6/6] mac80211: Enable initiating radiation on indoor
 channels
Message-ID: <20140125002134.GC28512@garbanzo.do-not-panic.com> (sfid-20140125_012145_932252_9F5EEEB1)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <1389801162-14488-7-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389801162-14488-7-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 15, 2014 at 05:52:42PM +0200, Ilan Peer wrote:
> +		if (!regulatory_ir_allowed(req->channels[0]) ||

Please keep in mind that the feature flag on the wiphy would
be used in your regulatory_ir_allowed() routine.

  Luis

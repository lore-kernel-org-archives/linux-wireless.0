Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58398 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaAYAYX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 19:24:23 -0500
Received: by mail-pb0-f45.google.com with SMTP id un15so3827767pbc.4
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 16:24:23 -0800 (PST)
Date: Fri, 24 Jan 2014 16:24:18 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [PATCH v2 0/6] Enable additional channels for use
Message-ID: <20140125002416.GD28512@garbanzo.do-not-panic.com> (sfid-20140125_012426_766941_658CF4AE)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 15, 2014 at 05:52:36PM +0200, Ilan Peer wrote:
> Hi Luis,
> 
> I'm resending this patch set. Any chance you could review it?

Looks good but needs a bit of work. In particular the biggest
concern I have is the last_request thing, and the feature flag
on the wiphy. Other than that, tons of cleanup and one last
requirement: please document this on the wireless wiki on the
regulatory page, once accepted.

http://wireless.kernel.org/en/developers/Regulatory/processing_rules

  Luis

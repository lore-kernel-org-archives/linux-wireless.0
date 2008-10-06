Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57740 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYJFTDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 15:03:44 -0400
Date: Mon, 6 Oct 2008 15:03:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com
Subject: Re: [PATCH 1/2] iwlwifi: fix compliation warning in iwl-agn-rs.c
	when CONFIG_IWLWIFI_DEBUG is not set.
Message-ID: <20081006190301.GE3448@tuxdriver.com> (sfid-20081006_210402_323679_4B65AD7A)
References: <eb3ff54b0810060658p2241a6d0k9c6f504d976e0f@mail.gmail.com> <1ba2fa240810060741o35c8071ere77460305b88545c@mail.gmail.com> <eb3ff54b0810060811p4798e4c0va59c5375d004f53d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eb3ff54b0810060811p4798e4c0va59c5375d004f53d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 05:11:40PM +0200, Rami Rosen wrote:

>  Second, this is also a possible solution; looking at the function
> immediately above in the same file  (rs_clear() in iwl-agn-rs.c)
> we can see the same usage of #ifdef CONFIG_IWLWIFI_DEBUG
> and not __maybe_unused.
> I wonder: does the  "__maybe_unused" solution better than the #ifdef
> solution  in any aspect?

Yes.

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.

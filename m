Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:40640 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0KBIc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 04:32:59 -0400
Date: Tue, 2 Nov 2010 09:32:58 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: Re: [PATCH 2/7] mwl8k: rf_tx_power cmd deprecated for AP firmware
Message-ID: <20101102083258.GO1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <1288659351-22313-2-git-send-email-brian@cozybit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1288659351-22313-2-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 01, 2010 at 05:55:46PM -0700, Brian Cavagnolo wrote:

> From: Nishant Sarmukadam <nishants@marvell.com>
> 
> For AP firmware, rf_tx_power command has been deprecated and
> replaced by tx_power command.

The commit message is misleading: s/deprecated/removed/.

Also, command names go in capitals.

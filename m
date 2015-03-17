Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbbCQTAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 15:00:49 -0400
Date: Tue, 17 Mar 2015 15:00:45 -0400 (EDT)
Message-Id: <20150317.150045.2177571124929326883.davem@redhat.com> (sfid-20150317_200153_551881_E6ABFFB2)
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, soren.brinkmann@xilinx.com,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	nios2-dev@lists.rocketboards.org, linuxppc-dev@lists.ozlabs.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/16 linux-next] drivers/net: constify of_device_id
 array
From: David Miller <davem@redhat.com>
In-Reply-To: <1426617469-781-1-git-send-email-fabf@skynet.be>
References: <1426617469-781-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 17 Mar 2015 19:37:31 +0100

> This small patchset adds const to of_device_id arrays in
> drivers/net branch.

Series applied, thanks.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbbADQrx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2015 11:47:53 -0500
Date: Sun, 4 Jan 2015 16:57:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Fred Chou <fred.chou.nd@gmail.com>
Cc: helmut.schaa@googlemail.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: rt2x00: use helper to check
 capability/requirement
Message-ID: <20150104155740.GA6764@redhat.com> (sfid-20150104_174835_861984_08AAA32B)
References: <1419581958-5927-1-git-send-email-fred.chou.nd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1419581958-5927-1-git-send-email-fred.chou.nd@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 26, 2014 at 04:19:18PM +0800, Fred Chou wrote:
> From: Fred Chou <fred.chou.nd@gmail.com>
> 
> Use rt2x00_has_cap_flag macro to check rt2x00dev->cap_flags. 
> 
> Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>


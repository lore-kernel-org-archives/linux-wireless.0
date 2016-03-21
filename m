Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbcCUHfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 03:35:16 -0400
Date: Mon, 21 Mar 2016 08:32:57 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: helmut.schaa@googlemail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6] rt2x00usb: Use usb anchor to manage URB
Message-ID: <20160321073256.GA14819@redhat.com> (sfid-20160321_083521_172911_B19C16D8)
References: <1458384061-22522-1-git-send-email-vishalthanki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458384061-22522-1-git-send-email-vishalthanki@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 19, 2016 at 11:41:01AM +0100, Vishal Thanki wrote:
> With current driver, it is observed that a URB is not
> completed while the USB disconnect is initiated. Due to
> that, the URB completion handler is trying to access
> the resource which was freed as a part of USB disconnect.
> Managing the URBs with anchor will make sure that all
> the URBs are handled gracefully before device gets
> disconnected.
> 
> Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

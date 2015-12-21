Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbbLUVSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 16:18:01 -0500
Date: Mon, 21 Dec 2015 13:17:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH RESEND 03/46] staging: wilc1000: rename index to
 tcp_pending_ack_idx
Message-ID: <20151221211745.GA13495@kroah.com> (sfid-20151221_221805_903360_6178C702)
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
 <1450675130-17866-4-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1450675130-17866-4-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2015 at 02:18:07PM +0900, Glen Lee wrote:
> This patch renames "index" of struct txq_entry_t to tcp_pending_ack_idx since
> this name could be confused index of txq_entry_t. It is index of tcp pending
> ack.
> 
> It fixes 8e55639d066f4ef402ba88fca08ed1be70e1c4da

You didn't describe this correctly :(

It should be:
	It fixes 8e55639d066f ("staging: wilc1000: rename
	tcp_PendingAck_index of struct txq_entry_t")

I'll edit it by hand this time :(


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59799 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbLVBtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 20:49:16 -0500
Message-ID: <5678AD04.80902@atmel.com> (sfid-20151222_024948_967500_90E945B8)
Date: Tue, 22 Dec 2015 10:53:08 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <austin.shin@atmel.com>,
	<linux-wireless@vger.kernel.org>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <tony.cho@atmel.com>,
	<leo.kim@atmel.com>, <adham.abozaeid@atmel.com>
Subject: Re: [PATCH RESEND 03/46] staging: wilc1000: rename index to tcp_pending_ack_idx
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com> <1450675130-17866-4-git-send-email-glen.lee@atmel.com> <20151221211745.GA13495@kroah.com>
In-Reply-To: <20151221211745.GA13495@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi greg,


On 2015년 12월 22일 06:17, Greg KH wrote:
> On Mon, Dec 21, 2015 at 02:18:07PM +0900, Glen Lee wrote:
>> This patch renames "index" of struct txq_entry_t to tcp_pending_ack_idx since
>> this name could be confused index of txq_entry_t. It is index of tcp pending
>> ack.
>>
>> It fixes 8e55639d066f4ef402ba88fca08ed1be70e1c4da
> You didn't describe this correctly :(
>
> It should be:
> 	It fixes 8e55639d066f ("staging: wilc1000: rename
> 	tcp_PendingAck_index of struct txq_entry_t")
>
> I'll edit it by hand this time :(

My mistake, thank you for doing this. I'll keep in mind.

regards,
glen lee

>


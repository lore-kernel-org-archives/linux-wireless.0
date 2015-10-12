Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27235 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbbJLCL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2015 22:11:26 -0400
Subject: Re: staging: wilc1000: WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	<johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<chris.park@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<gregkh@linuxfoundation.org>
References: <5616B60F.7040804@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<linux-kernel@vger.kernel.org>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <561B16BC.6060201@atmel.com> (sfid-20151012_041222_842292_0BE579E2)
Date: Mon, 12 Oct 2015 11:11:08 +0900
MIME-Version: 1.0
In-Reply-To: <5616B60F.7040804@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 09일 03:29, Stanislav Kholmanskikh wrote:
> Hi!
>
> I noticed that drivers/staging/wilc1000/Kconfic defines:
>
> config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
>          bool "Dynamically allocate memory in real time"
>          ---help---
>            This choice supports dynamic allocation of the memory
>            for the receive buffer. The driver will allocate the RX buffer
>            when it is required.
>
>
> "MEMROY" looks suspicious. Is it a typo (MEMORY?) or by intent?

These parts will be wholly changed but I need to get important driver updates. It will be done soon.

Thanks for your review,

Tony.

> Thanks!


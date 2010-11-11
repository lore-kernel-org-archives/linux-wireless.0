Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0KKRvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 12:51:46 -0500
Subject: Re: Overload Probe Request to send data
From: Johannes Berg <johannes@sipsolutions.net>
To: Cassiano Tartari <cassianotartari@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinDJxnMHEbQjUwWjT2MnW5r7gcxoZW7bZetT7a9@mail.gmail.com>
References: <AANLkTinDJxnMHEbQjUwWjT2MnW5r7gcxoZW7bZetT7a9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 09:53:08 -0800
Message-ID: <1289497988.3695.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 13:35 -0200, Cassiano Tartari wrote:
> Hi,
> 
>     I'd like to know if somebody could help me giving a way to modify
> the iwlwifi driver to overload the Probe Requests to send data? Which
> file I need to modify, for what word I need search for...

Just give the data to iw in a vendor specific IE and iwlwifi will send
it out. Don't modify the kernel at all.

johannes


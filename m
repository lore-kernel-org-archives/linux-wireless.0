Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53828 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3LQFuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 00:50:24 -0500
Received: by mail-pd0-f178.google.com with SMTP id y10so6324863pdj.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 21:50:22 -0800 (PST)
Message-ID: <52AFE619.1060104@gmail.com> (sfid-20131217_065038_077560_00461BBE)
Date: Tue, 17 Dec 2013 11:20:17 +0530
From: Ujjal Roy <royujjal@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	David Herrmann <dh.herrmann@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] P2P setup timeout
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>	 <1387197416.4665.15.camel@jlt4.sipsolutions.net>	 <CANq1E4TAt_Pw-V5_2LtJjY3LRcuwsxr1mBkcHjmX+MJUxc=zPQ@mail.gmail.com>	 (sfid-20131216_143914_205158_56AAC54B) <1387201528.2057.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1387201528.2057.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 12/16/2013 07:15 PM, Johannes Berg wrote:
> On Mon, 2013-12-16 at 14:39 +0100, David Herrmann wrote:
>
> Right, and I suspect they don't get a response because (as the sniffer
> trace tells me) they're sent with 1 Mbps (a CCK rate), which is invalid
> in the P2P spec (must use OFDM).
>

Can you please let me know, is the P2P spec freely available to read or 
download? If so, please provide some info from where I can able to get 
the document. Actually, I need to know - how to add P2P_DEVICE support 
in a driver.

Thanks,
UjjaL

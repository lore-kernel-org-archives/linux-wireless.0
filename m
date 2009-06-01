Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37224 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZFANFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 09:05:24 -0400
Received: by ewy24 with SMTP id 24so7798535ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 06:05:24 -0700 (PDT)
Message-ID: <4A23D212.5040003@tuffmail.co.uk>
Date: Mon, 01 Jun 2009 14:05:22 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: create useful userspace interface
References: <1243524688.10632.0.camel@johannes.local>	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>	 <1243763887.19302.29.camel@johannes.local>	 <1243796509.6570.35.camel@localhost.localdomain>	 <1243841639.5299.8.camel@johannes.local>  <4A238EA2.4040106@tuffmail.co.uk> <1243858256.5299.14.camel@johannes.local>
In-Reply-To: <1243858256.5299.14.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Would everybody be happy with this rolled in?
>
> johannes
>
> Subject: rfkill: userspace API improvements
>
> This adds the two following things to /dev/rfkill:
>  1) notification to userspace with a new operation
>     RFKILL_OP_NVS_REPORT about default states restored
>     from platform non-volatile storage
>  2) the ability to ignore input events in the kernel
>     while a handler daemon is connected, if the input
>     part is compiled in.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>   

Sounds reasonable.  Thanks for responding to these concerns.

Alan

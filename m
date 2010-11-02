Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57373 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab0KBCpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 22:45:45 -0400
Received: by vws13 with SMTP id 13so4381646vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 19:45:45 -0700 (PDT)
Message-ID: <4CCF7B73.7040906@lwfinger.net>
Date: Mon, 01 Nov 2010 21:46:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>
In-Reply-To: <309278.75116.qm@web29520.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2010 09:42 PM, Hin-Tak Leung wrote:
> 
> --- On Tue, 2/11/10, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
>> We were using wrong address for BRSR
>> (Basic Rate Set Register) while
>> initializing its value, comparing with Realtek sources, for
>> 8187B case.
>>
>> Also, the same register is initialized in
>> rtl8187b_reg_table, so remove
>> the duplicate initialization from the table.
>>
>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> 
> ANAPARAM* stands for "anonymous parameters", right?  One of these days we should give them some meaningful names. 

I have always thought it was for "analog parameter". Am I wrong?

Larry

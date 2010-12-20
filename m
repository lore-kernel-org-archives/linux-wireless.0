Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33506 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234Ab0LTWWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 17:22:07 -0500
Received: by vws16 with SMTP id 16so1513346vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 14:22:07 -0800 (PST)
Message-ID: <4D0FD710.8070103@lwfinger.net>
Date: Mon, 20 Dec 2010 16:22:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rtl818x: move rtl8180 and rtl8187 to separate subdirectories
References: <22404.31613.qm@web29501.mail.ird.yahoo.com>
In-Reply-To: <22404.31613.qm@web29501.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2010 03:34 PM, Hin-Tak Leung wrote:
> --- On Mon, 20/12/10, John W. Linville <linville@tuxdriver.com> wrote:
> 
>> These drivers share one header file,
>> but nothing else.  Worse, both
>> drivers use the rtl8225 part with different register
>> settings.  The
>> results has been some ugly naming -- let's simplify that.
>>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> 
> 
> Seems reasonable.

To me as well. In fact, this should cure a buglet that I have noticed in that
rtl8180 was rebuilt whenever rtl8187 was changed.

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:20088 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZHJO1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 10:27:42 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1010616rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 07:27:43 -0700 (PDT)
Message-ID: <4A802E5B.8040800@lwfinger.net>
Date: Mon, 10 Aug 2009 09:27:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linville@tuxdriver.com,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl818x: Add some documentation to the TX desc flags
References: <200908091757.31010.mb@bu3sch.de>
In-Reply-To: <200908091757.31010.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Add some TX desc flags docs.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> It's incomplete. Just the ones I could easily figure out by myself...

ack

Thanks for the start. In a quick check, the one you didn't fill in
(RTL818X_TX_DESC_FLAG_RX_UNDER) is not used and should be removed.
I'll do that and add the RX desc flags.

Larry



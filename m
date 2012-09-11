Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56568 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408Ab2IKRXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 13:23:40 -0400
Received: by eaac11 with SMTP id c11so395113eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Sep 2012 10:23:39 -0700 (PDT)
Date: Tue, 11 Sep 2012 19:23:27 +0200
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
	Li Chaoming <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtlwifi: rtl8192ce: Log message that B_CUT device may
 not work
Message-ID: <20120911192327.62fec16a@destiny.ordissimo> (sfid-20120911_192349_416608_E5A04767)
In-Reply-To: <1347379873-9390-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1347379873-9390-1-git-send-email-Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 11 Sep 2012 11:11:13 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :

> There are a number of problems that occur for the latest version
> of the Realtek RTL8188CE device with the in-kernel driver. These
> include selection of the wrong firmware, and system lockup. A full
> fix is known, but is too invasive for inclusion in stable. This patch
> fixes the problem with loading the wrong firmware, and logs a message
> that the device may not work for kernels 3.6 and older.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> Cc: Anisse Astier <anisse@astier.eu>
> Cc: Li Chaoming <chaoming_li@realsil.com.cn>

Tested-by: Anisse Astier <anisse@astier.eu>

Behaves as expected: I can see the warning then about 20 seconds later
the machine locks up.

Regards,

Anisse

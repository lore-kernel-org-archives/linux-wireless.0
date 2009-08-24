Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57948 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZHXIIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 04:08:54 -0400
Message-ID: <4A924A77.50608@nokia.com>
Date: Mon, 24 Aug 2009 11:08:23 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "ext John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] wl1271: remove print_mac usage
References: <1250607301-24944-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1250607301-24944-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext John W. Linville wrote:
>   CC [M]  drivers/net/wireless/wl12xx/wl1271_main.o
> drivers/net/wireless/wl12xx/wl1271_main.c: In function ‘wl1271_op_add_interface’:
> drivers/net/wireless/wl12xx/wl1271_main.c:611: warning: ‘print_mac’ is deprecated (declared at include/linux/if_ether.h:142)
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>   

Thanks John.

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.


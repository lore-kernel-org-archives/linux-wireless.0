Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2076 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab3C2N07 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 09:26:59 -0400
Message-ID: <515593A6.5000101@broadcom.com> (sfid-20130329_142703_122859_D66D237B)
Date: Fri, 29 Mar 2013 14:14:14 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Akinobu Mita" <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH -mmotm resend] brcm80211: fix the misaligned
 indentation
References: <1364560400-30242-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1364560400-30242-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2013 01:33 PM, Akinobu Mita wrote:
> This fixes the misaligned indentation introduced by
> drivers-net-rename-random32-to-prandom_u32.patch in the -mm tree.
> 
> This also remove unneeded parentheses in order not to cause line over
> 80 characters.
> 

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
> Cc: Hante Meuleman <meuleman@broadcom.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list@broadcom.com



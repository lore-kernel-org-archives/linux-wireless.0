Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34832 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1CROuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:50:23 -0400
Received: by qwk3 with SMTP id 3so2862984qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:50:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
References: <1300449773-11255-1-git-send-email-zajec5@gmail.com>
	<1300453433.13499.18.camel@dev.znau.edu.ua>
	<AANLkTimG8G_BsqoAUYWfRETfU1ndu_i87WjkXx+v_sNE@mail.gmail.com>
Date: Fri, 18 Mar 2011 15:50:22 +0100
Message-ID: <AANLkTi=EeMKNsi9bxNg4RJre-pP=jqcGpbLPNtggSK0N@mail.gmail.com>
Subject: Re: [RFC][PATCH] ssb: separate common scanning functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/3/18 Rafał Miłecki <zajec5@gmail.com>:
> What for example about pci.c? Which functions from that file won't be
> duplicated in totally separated?

At first I though we will need to duplicate all pci routines like
ssb_pci_switch_coreidx and ssb_pci_xtal. But now I've checked
brcm80211 and it seems it reads SPROM even from AI bus-cards.

Do you really want to duplicate all the SPROM code in *totally
separated* driver for AI?!

-- 
Rafał

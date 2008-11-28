Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:31236 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYK1CJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 21:09:26 -0500
Received: by nf-out-0910.google.com with SMTP id d3so660970nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 18:09:24 -0800 (PST)
Message-ID: <3ace41890811271809q19a034alfa89a501c892a3df@mail.gmail.com> (sfid-20081128_030930_571806_D8201670)
Date: Fri, 28 Nov 2008 02:09:24 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: herton <herton@mandriva.com.br>
Subject: Re: [PATCH] rtl8187: fix retry count passed in rtl8187_tx
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200811272253.24604.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200811272253.24604.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 28, 2008 at 12:53 AM, herton <herton@mandriva.com.br> wrote:
> I mistakenly changed retry count passed in rtl8187_tx in previous change
> "rtl8187: feedback transmitted packets using tx close descriptor for
> 8187B". For 8187 it should represent the number of retries (retry count
> limit). As explained by Johannes Berg, .count represents the number of
> tries (not retries), and retries = tries - 1.
>
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

Just rebuilt, did not expect any problem and there isn't.

Hin-Tak

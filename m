Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39232 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1GSWxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 18:53:17 -0400
Received: by gxk21 with SMTP id 21so1997379gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 15:53:16 -0700 (PDT)
Message-ID: <4E260ADA.6060408@lwfinger.net> (sfid-20110720_005323_631898_BFA37DEB)
Date: Tue, 19 Jul 2011 17:53:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 1/3] b43: replace DMA translation workarounds with just
 a one, commented
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com> <1311113542-2540-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1311113542-2540-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2011 05:12 PM, Rafał Miłecki wrote:
> Routing bits are always placed in 0xC0000000, there is no any special
> bit shifting for 64-bit DMA. We just workaround wrong value (passed by
> ssb) in this way. Replace that with just a one workaround and comment
> it. Real fix for this requires testing with all ssb drivers.

If you wish to supply the real patch, I can test b43legacy.

Larry

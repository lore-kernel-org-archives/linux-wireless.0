Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:13891 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZHVRN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 13:13:59 -0400
Received: by wa-out-1112.google.com with SMTP id j5so270875wah.21
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2009 10:14:01 -0700 (PDT)
Message-ID: <4A902709.4080001@lwfinger.net>
Date: Sat, 22 Aug 2009 12:12:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
References: <200908220038.35564.herton@mandriva.com.br>
In-Reply-To: <200908220038.35564.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> This change implements rfkill support for RTL8187B and RTL8187L devices,
> using new cfg80211 rfkill API.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> ---

I don't have an RFKILL switch on my rtl8187 devices and cannot test
that part; however, everything looks OK and the devices still work.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

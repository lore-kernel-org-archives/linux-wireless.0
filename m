Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57917 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbbEZNwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:52:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2,
 1/2] adm8211: fix checkpatch errors for indentation and new line
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150511115325.GA5092@bytefire-computer>
To: Okash Khawaja <okash.khawaja@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20150526104802.E5F631416A0@smtp.codeaurora.org> (sfid-20150526_155350_298531_128289EA)
Date: Tue, 26 May 2015 10:48:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch fixes these checkpatch.pl errors around a single switch-case
> block:
> 
> ERROR: switch and case should be at the same indent
> ERROR: trailing statements should be on next line
> 
> More specifically, the fix has been applied to the five occurances of
> the errors listed below.
> 
> ERROR: switch and case should be at the same indent
> #1100: FILE: adm8211.c:1100:
> +               switch (cline) {
> [...]
> +                 default: reg |= (0x0 << 14);
> 
> ERROR: trailing statements should be on next line
> #1101: FILE: adm8211.c:1101:
> +               case  0x8: reg |= (0x1 << 14);
> 
> ERROR: trailing statements should be on next line
> #1103: FILE: adm8211.c:1103:
> +               case 0x16: reg |= (0x2 << 14);
> 
> ERROR: trailing statements should be on next line
> #1105: FILE: adm8211.c:1105:
> +               case 0x32: reg |= (0x3 << 14);
> 
> ERROR: trailing statements should be on next line
> #1107: FILE: adm8211.c:1107:
> +                 default: reg |= (0x0 << 14);
> 
> 
> Signed-off-by: Okash Khawaja <okash.khawaja@gmail.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

f5c65f38912e adm8211: fix checkpatch errors for indentation and new line
fe0a483ecf44 adm8211: fixed the possible pci cache line sizes inside switch-case

Kalle Valo

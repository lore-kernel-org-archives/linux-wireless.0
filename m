Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36316 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbbJVS4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 14:56:50 -0400
Received: by lffz202 with SMTP id z202so59189307lff.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2015 11:56:48 -0700 (PDT)
Subject: Re: [PATCH v4 14/15] net: wireless: ath: Remove unneeded variable ret
 returning 0
To: Punit Vara <punitvara@gmail.com>, jirislaby@gmail.com
References: <1445539670-4018-1-git-send-email-punitvara@gmail.com>
Cc: mickflemm@gmail.com, mcgrof@do-not-panic.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <5629316E.60106@cogentembedded.com> (sfid-20151022_205734_560935_C56C12CF)
Date: Thu, 22 Oct 2015 21:56:46 +0300
MIME-Version: 1.0
In-Reply-To: <1445539670-4018-1-git-send-email-punitvara@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2015 09:47 PM, Punit Vara wrote:

> Remove black line suggested by Sergei

    Such kind of comments should be under the --- tear line.

>
> This patch is to the ath5k/eeprom.c that fixes up warning caught by
> coccicheck:
>
> Unneeded variable: "ret". Return "0" on line 980
>
> Remove unneeded variable ret created to return zero.
>
> Signed-off-by: Punit Vara <punitvara@gmail.com>
[...]

MBR, Sergei


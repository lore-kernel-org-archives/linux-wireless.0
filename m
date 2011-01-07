Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:61172 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1AGBvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 20:51:50 -0500
Received: by iyf40 with SMTP id 40so7630307iyf.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 17:51:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D2632A6.9040307@canonical.com>
References: <1294348725-31239-1-git-send-email-tim.gardner@canonical.com> <4D2632A6.9040307@canonical.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 6 Jan 2011 17:51:29 -0800
Message-ID: <AANLkTi=oxpt4TJJMAPzq2+EZ17Z_R2wOzcqWtZ-+kqC4@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless linux-2.6.37.y, fix compile error for pm_qos_add_request()
To: tim.gardner@canonical.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 1:22 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> On 01/06/2011 02:18 PM, Tim Gardner wrote:
>>
>> rtg
>> ----
>
> git send-email clipped my annotation. It should have said:
>
> "Compile tested against 2.6.32.25 and 2.6.35.8"

Awesome, thanks, applied, pushed and made two new releases with this,
a -2 release.

  Luis

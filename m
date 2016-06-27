Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34171 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcF0ASg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2016 20:18:36 -0400
Subject: Re: [PATCH] rtlwifi: Add missing newlines to RT_TRACE calls
To: Joe Perches <joe@perches.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
References: <5677791872bfb47963780c198c825d882456720f.1466969647.git.joe@perches.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <577070D9.5080503@lwfinger.net> (sfid-20160627_021857_432245_9868049A)
Date: Sun, 26 Jun 2016 19:18:33 -0500
MIME-Version: 1.0
In-Reply-To: <5677791872bfb47963780c198c825d882456720f.1466969647.git.joe@perches.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/26/2016 02:34 PM, Joe Perches wrote:
> RT_TRACE does not add a newline to the end of a message and always
> emits at KERN_DEBUG so these are susceptible to message interleaving
> from other processes without the newline.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

This patch does not apply to the wireless-drivers-next repo. Which one did you use?

Larry


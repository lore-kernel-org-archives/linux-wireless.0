Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43519 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbbAVSNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 13:13:39 -0500
Received: by mail-wi0-f169.google.com with SMTP id bs8so42014799wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 10:13:38 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: p54pci: add handling of signal case
Date: Thu, 22 Jan 2015 19:13:36 +0100
Message-ID: <3408449.HHJmDQhAJs@debian64> (sfid-20150122_191343_851240_3AAC3302)
In-Reply-To: <1421731577-13324-1-git-send-email-der.herr@hofr.at>
References: <1421731577-13324-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 20, 2015 06:26:17 AM Nicholas Mc Guire wrote:
> if(!wait_for_completion_interruptible_timeout(...))
> only handles the timeout case - this patch adds handling the
> signal case the same as timeout.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

